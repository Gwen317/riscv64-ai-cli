//go:build !headless

package app

import (
	"context"
	"io"
	"os"

	"charm.land/lipgloss/v2"
	"github.com/charmbracelet/crush/internal/format"
	"github.com/charmbracelet/crush/internal/ui/anim"
	"github.com/charmbracelet/crush/internal/ui/styles"
	"github.com/charmbracelet/x/exp/charmtone"
)

type appSpinner interface {
	Stop()
}

func newAppSpinner(
	ctx context.Context,
	cancel context.CancelFunc,
	output io.Writer,
	hideSpinner bool,
	stdinTTY bool,
	stdoutTTY bool,
	stderrTTY bool,
) appSpinner {
	if hideSpinner || !stderrTTY {
		return nil
	}

	t := styles.DefaultStyles()
	hasDarkBG := true
	if f, ok := output.(*os.File); ok && stdinTTY && stdoutTTY {
		hasDarkBG = lipgloss.HasDarkBackground(os.Stdin, f)
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
