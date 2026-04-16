//go:build headless

package cmd

import (
	"fmt"

	"github.com/charmbracelet/crush/internal/client"
	"github.com/charmbracelet/crush/internal/proto"
	"github.com/charmbracelet/crush/internal/workspace"
	"github.com/spf13/cobra"
)

func addHostFlag(cmd *cobra.Command) {
}

func setupClientServerWorkspace(cmd *cobra.Command) (workspace.Workspace, func(), error) {
	return nil, nil, fmt.Errorf("client/server mode is not supported in headless builds")
}

func connectToServer(cmd *cobra.Command) (*client.Client, *proto.Workspace, func(), error) {
	return nil, nil, nil, fmt.Errorf("client/server mode is not supported in headless builds")
}
