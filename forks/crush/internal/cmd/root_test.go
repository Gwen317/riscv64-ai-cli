package cmd

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestMaybePrependStdinFromPipe(t *testing.T) {
	oldStdin := os.Stdin
	r, w, err := os.Pipe()
	require.NoError(t, err)
	defer func() {
		os.Stdin = oldStdin
	}()

	_, err = w.WriteString("from stdin")
	require.NoError(t, err)
	require.NoError(t, w.Close())

	os.Stdin = r
	defer r.Close()

	got, err := MaybePrependStdin("prompt")
	require.NoError(t, err)
	require.Equal(t, "from stdin\n\nprompt", got)
}

func TestMaybePrependStdinEmptyPipe(t *testing.T) {
	oldStdin := os.Stdin
	r, w, err := os.Pipe()
	require.NoError(t, err)
	defer func() {
		os.Stdin = oldStdin
	}()

	require.NoError(t, w.Close())
	os.Stdin = r
	defer r.Close()

	got, err := MaybePrependStdin("prompt")
	require.NoError(t, err)
	require.Equal(t, "\n\nprompt", got)
}

func TestCreateDotCrushDirWritesDefaultGitIgnore(t *testing.T) {
	t.Parallel()

	dir := t.TempDir()
	require.NoError(t, createDotCrushDir(dir))

	content, err := os.ReadFile(filepath.Join(dir, ".gitignore"))
	require.NoError(t, err)
	require.Equal(t, defaultGitIgnore, string(content))
}

func TestCreateDotCrushDirUpgradesOldGitIgnore(t *testing.T) {
	t.Parallel()

	dir := t.TempDir()
	gitIgnorePath := filepath.Join(dir, ".gitignore")
	require.NoError(t, os.WriteFile(gitIgnorePath, []byte(oldGitIgnore), 0o644))

	require.NoError(t, createDotCrushDir(dir))

	content, err := os.ReadFile(gitIgnorePath)
	require.NoError(t, err)
	require.Equal(t, defaultGitIgnore, string(content))
}
