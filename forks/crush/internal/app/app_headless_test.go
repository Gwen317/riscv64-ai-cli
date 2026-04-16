package app

import (
	"testing"

	"github.com/charmbracelet/crush/internal/config"
	"github.com/stretchr/testify/require"
)

func TestValidateNonInteractiveCapabilitiesAllowsHeadlessWithoutMCP(t *testing.T) {
	t.Parallel()

	cfg := &config.Config{}
	err := validateNonInteractiveCapabilities(cfg, Options{Headless: true})
	require.NoError(t, err)
}

func TestValidateNonInteractiveCapabilitiesRejectsHeadlessMCP(t *testing.T) {
	t.Parallel()

	cfg := &config.Config{
		MCP: config.MCPs{
			"demo": {},
		},
	}
	err := validateNonInteractiveCapabilities(cfg, Options{Headless: true})
	require.Error(t, err)
	require.Contains(t, err.Error(), "does not support MCP")
}
