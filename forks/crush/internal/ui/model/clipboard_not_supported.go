//go:build !(darwin || linux || windows) || arm || 386 || ios || android || riscv64

package model

func readClipboard(clipboardFormat) ([]byte, error) {
	return nil, errClipboardPlatformUnsupported
}
