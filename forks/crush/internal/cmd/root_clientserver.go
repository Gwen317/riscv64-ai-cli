//go:build !headless

package cmd

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"log/slog"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"time"

	"github.com/charmbracelet/crush/internal/client"
	"github.com/charmbracelet/crush/internal/config"
	"github.com/charmbracelet/crush/internal/event"
	crushlog "github.com/charmbracelet/crush/internal/log"
	"github.com/charmbracelet/crush/internal/proto"
	"github.com/charmbracelet/crush/internal/server"
	"github.com/charmbracelet/crush/internal/version"
	"github.com/charmbracelet/crush/internal/workspace"
	"github.com/spf13/cobra"
)

var clientHost string

func addHostFlag(cmd *cobra.Command) {
	cmd.PersistentFlags().StringVarP(&clientHost, "host", "H", server.DefaultHost(), "Connect to a specific crush server host (for advanced users)")
}

func setupClientServerWorkspace(cmd *cobra.Command) (workspace.Workspace, func(), error) {
	c, protoWs, cleanupServer, err := connectToServer(cmd)
	if err != nil {
		return nil, nil, err
	}

	clientWs := workspace.NewClientWorkspace(c, *protoWs)

	if protoWs.Config.IsConfigured() {
		if err := clientWs.InitCoderAgent(cmd.Context()); err != nil {
			slog.Error("Failed to initialize coder agent", "error", err)
		}
	}

	return clientWs, cleanupServer, nil
}

func connectToServer(cmd *cobra.Command) (*client.Client, *proto.Workspace, func(), error) {
	hostURL, err := server.ParseHostURL(clientHost)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("invalid host URL: %v", err)
	}

	if err := ensureServer(cmd, hostURL); err != nil {
		return nil, nil, nil, err
	}

	debug, _ := cmd.Flags().GetBool("debug")
	yolo, _ := cmd.Flags().GetBool("yolo")
	dataDir, _ := cmd.Flags().GetString("data-dir")
	ctx := cmd.Context()

	cwd, err := ResolveCwd(cmd)
	if err != nil {
		return nil, nil, nil, err
	}

	c, err := client.NewClient(cwd, hostURL.Scheme, hostURL.Host)
	if err != nil {
		return nil, nil, nil, err
	}

	wsReq := proto.Workspace{
		Path:    cwd,
		DataDir: dataDir,
		Debug:   debug,
		YOLO:    yolo,
		Version: version.Version,
		Env:     os.Environ(),
	}

	ws, err := c.CreateWorkspace(ctx, wsReq)
	if err != nil {
		for range 5 {
			select {
			case <-ctx.Done():
				return nil, nil, nil, ctx.Err()
			case <-time.After(200 * time.Millisecond):
			}
			ws, err = c.CreateWorkspace(ctx, wsReq)
			if err == nil {
				break
			}
		}
		if err != nil {
			return nil, nil, nil, fmt.Errorf("failed to create workspace: %v", err)
		}
	}

	if shouldEnableMetrics(ws.Config) {
		event.Init()
	}

	if ws.Config != nil {
		logFile := filepath.Join(ws.Config.Options.DataDirectory, "logs", "crush.log")
		crushlog.Setup(logFile, debug)
	}

	cleanup := func() { _ = c.DeleteWorkspace(context.Background(), ws.ID) }
	return c, ws, cleanup, nil
}

func ensureServer(cmd *cobra.Command, hostURL *url.URL) error {
	switch hostURL.Scheme {
	case "unix", "npipe":
		needsStart := false
		if _, err := os.Stat(hostURL.Host); err != nil && errors.Is(err, fs.ErrNotExist) {
			needsStart = true
		} else if err == nil {
			if err := restartIfStale(cmd, hostURL); err != nil {
				slog.Warn("Failed to check server version, restarting", "error", err)
				needsStart = true
			}
			if _, err := os.Stat(hostURL.Host); err != nil && errors.Is(err, fs.ErrNotExist) {
				needsStart = true
			}
		}

		if needsStart {
			return startDetachedServer(cmd)
		}
	}

	return nil
}

func restartIfStale(cmd *cobra.Command, hostURL *url.URL) error {
	c, err := client.NewClient("", hostURL.Scheme, hostURL.Host)
	if err != nil {
		return err
	}
	vi, err := c.VersionInfo(cmd.Context())
	if err != nil {
		return err
	}
	if vi.Version == version.Version {
		return nil
	}
	slog.Info("Server version mismatch, restarting", "server", vi.Version, "client", version.Version)
	_ = c.ShutdownServer(cmd.Context())
	for range 20 {
		if _, err := os.Stat(hostURL.Host); errors.Is(err, fs.ErrNotExist) {
			break
		}
		select {
		case <-cmd.Context().Done():
			return cmd.Context().Err()
		case <-time.After(100 * time.Millisecond):
		}
	}
	_ = os.Remove(hostURL.Host)
	return nil
}

var safeNameRegexp = regexp.MustCompile(`[^a-zA-Z0-9._-]`)

func startDetachedServer(cmd *cobra.Command) error {
	exe, err := os.Executable()
	if err != nil {
		return fmt.Errorf("failed to determine executable path: %v", err)
	}
	safeClientHost := safeNameRegexp.ReplaceAllString(clientHost, "_")
	chDir := filepath.Join(config.GlobalCacheDir(), "server-"+safeClientHost)
	if err := os.MkdirAll(chDir, 0o700); err != nil {
		return fmt.Errorf("failed to create server working directory: %v", err)
	}

	cmdArgs := []string{"server"}
	if clientHost != server.DefaultHost() {
		cmdArgs = append(cmdArgs, "--host", clientHost)
	}

	c := exec.CommandContext(cmd.Context(), exe, cmdArgs...)
	stdoutPath := filepath.Join(chDir, "stdout.log")
	stderrPath := filepath.Join(chDir, "stderr.log")
	detachProcess(c)

	stdout, err := os.Create(stdoutPath)
	if err != nil {
		return fmt.Errorf("failed to create stdout log file: %v", err)
	}
	defer stdout.Close()
	c.Stdout = stdout

	stderr, err := os.Create(stderrPath)
	if err != nil {
		return fmt.Errorf("failed to create stderr log file: %v", err)
	}
	defer stderr.Close()
	c.Stderr = stderr

	if err := c.Start(); err != nil {
		return fmt.Errorf("failed to start crush server: %v", err)
	}

	if err := c.Process.Release(); err != nil {
		return fmt.Errorf("failed to detach crush server process: %v", err)
	}

	return nil
}
