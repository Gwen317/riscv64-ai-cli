//go:build !headless

package cmd

func isHeadlessBuild() bool {
	return false
}
