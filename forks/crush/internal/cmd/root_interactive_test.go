//go:build !headless

package cmd

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateInteractiveTerminalAcceptsTTY(t *testing.T) {
	t.Parallel()

	err := validateInteractiveTerminal(true, true)
	require.NoError(t, err)
}

func TestValidateInteractiveTerminalRejectsNonTTY(t *testing.T) {
	t.Parallel()

	err := validateInteractiveTerminal(false, true)
	require.Error(t, err)
	require.Contains(t, err.Error(), "requires a real terminal")
}
