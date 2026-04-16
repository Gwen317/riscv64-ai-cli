//go:build headless

package config

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestApplyLSPDefaultsHeadlessNoop(t *testing.T) {
	t.Parallel()

	cfg := &Config{
		LSP: map[string]LSPConfig{
			"gopls": {
				Command: "gopls",
			},
		},
	}

	cfg.applyLSPDefaults()

	got := cfg.LSP["gopls"]
	require.Empty(t, got.RootMarkers)
	require.Empty(t, got.FileTypes)
	require.Nil(t, got.Options)
	require.Nil(t, got.InitOptions)
}
