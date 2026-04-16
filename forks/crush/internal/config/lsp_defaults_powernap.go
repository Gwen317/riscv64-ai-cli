//go:build !headless

package config

import (
	"cmp"

	powernapConfig "github.com/charmbracelet/x/powernap/pkg/config"
)

// applyLSPDefaults applies default values from powernap to LSP configurations.
func (c *Config) applyLSPDefaults() {
	configManager := powernapConfig.NewManager()
	configManager.LoadDefaults()

	for name, cfg := range c.LSP {
		base, ok := configManager.GetServer(name)
		if !ok {
			base, ok = configManager.GetServer(cfg.Command)
			if !ok {
				continue
			}
		}
		if cfg.Options == nil {
			cfg.Options = base.Settings
		}
		if cfg.InitOptions == nil {
			cfg.InitOptions = base.InitOptions
		}
		if len(cfg.FileTypes) == 0 {
			cfg.FileTypes = base.FileTypes
		}
		if len(cfg.RootMarkers) == 0 {
			cfg.RootMarkers = base.RootMarkers
		}
		cfg.Command = cmp.Or(cfg.Command, base.Command)
		if len(cfg.Args) == 0 {
			cfg.Args = base.Args
		}
		if len(cfg.Env) == 0 {
			cfg.Env = base.Environment
		}
		c.LSP[name] = cfg
	}
}
