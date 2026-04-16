//go:build headless

package cmd

import "context"

type runSpinner interface {
	Stop()
}

func newRunSpinner(context.Context, context.CancelFunc, bool, bool, bool, bool) runSpinner {
	return nil
}
