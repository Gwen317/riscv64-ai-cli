//go:build headless

package cmd

import (
	"context"
	"log/slog"
	"os"

	fang "charm.land/fang/v2"
	"github.com/charmbracelet/crush/internal/version"
	"github.com/spf13/cobra"
)

func init() {
	addPersistentRootFlags(rootCmd)
	addHeadlessRootCommands(rootCmd)
}

var rootCmd = &cobra.Command{
	Use:   "crush",
	Short: "A headless AI assistant for software development",
	Long:  "A minimal headless Crush build focused on non-interactive runtime workflows",
	Example: `
# Run non-interactively
crush run "Summarize this project"

# List configured models
crush models

# Print data directories
crush dirs
  `,
	RunE: func(cmd *cobra.Command, args []string) error {
		return cmd.Help()
	},
}

func Execute() {
	slog.SetDefault(slog.New(slog.DiscardHandler))

	if err := fang.Execute(
		context.Background(),
		rootCmd,
		fang.WithVersion(version.Version),
		fang.WithNotifySignal(os.Interrupt),
	); err != nil {
		os.Exit(1)
	}
}
