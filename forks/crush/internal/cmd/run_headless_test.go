//go:build headless

package cmd

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateRunModeForBuildRejectsClientServerInHeadless(t *testing.T) {
	t.Parallel()

	err := validateRunModeForBuild(true)
	require.Error(t, err)
	require.Contains(t, err.Error(), "client/server mode is not supported")
}

func TestValidateRunModeForBuildAllowsLocalHeadlessRun(t *testing.T) {
	t.Parallel()

	err := validateRunModeForBuild(false)
	require.NoError(t, err)
}
