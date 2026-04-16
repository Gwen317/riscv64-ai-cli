//go:build !headless

package cmd

import "fmt"

func validateInteractiveTerminal(stdinTTY, stdoutTTY bool) error {
	if stdinTTY && stdoutTTY {
		return nil
	}
	return fmt.Errorf("interactive mode requires a real terminal on both stdin and stdout; use 'crush run ...' for non-interactive use or launch the TUI from a normal SSH terminal")
}
