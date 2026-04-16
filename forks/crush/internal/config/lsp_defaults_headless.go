//go:build headless

package config

// applyLSPDefaults is a no-op in headless builds to avoid pulling interactive
// LSP default metadata into the minimal runtime slice.
func (c *Config) applyLSPDefaults() {
}
