//go:build headless

package app

import (
	"context"
	"io"
)

type appSpinner interface {
	Stop()
}

func newAppSpinner(context.Context, context.CancelFunc, io.Writer, bool, bool, bool, bool) appSpinner {
	return nil
}
