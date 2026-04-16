//go:build !headless

package cmd

import (
	"context"
	"os"

	"charm.land/lipgloss/v2"
	"github.com/charmbracelet/crush/internal/format"
	"github.com/charmbracelet/crush/internal/ui/anim"
	"github.com/charmbracelet/crush/internal/ui/styles"
	"github.com/charmbracelet/x/exp/charmtone"
)

type runSpinner interface {
	Stop()
}

func newRunSpinner(
	ctx context.Context,
	cancel context.CancelFunc,
	hideSpinner bool,
	stdinTTY bool,
	stdoutTTY bool,
	stderrTTY bool,
) runSpinner {
	if hideSpinner || !stderrTTY {
		return nil
	}

	t := styles.DefaultStyles()
	hasDarkBG := true
	if stdinTTY && stdoutTTY {
		hasDarkBG = lipgloss.HasDarkBackground(os.Stdin, os.Stdout)
	}
	defaultFG := lipgloss.LightDark(hasDarkBG)(charmtone.Pepper, t.FgBase)

	spinner := format.NewSpinner(ctx, cancel, anim.Settings{
		Size:        10,
		Label:       "Generating",
		LabelColor:  defaultFG,
		GradColorA:  t.Primary,
		GradColorB:  t.Secondary,
		CycleColors: true,
	})
	spinner.Start()
	return spinner
}
