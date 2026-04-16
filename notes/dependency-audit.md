# Dependency Audit

## Source baseline

- Upstream repo: `https://github.com/charmbracelet/crush`
- Checked commit: `a210bfbb3dd9b433b3c6445da93ba810f96f8e19`
- Module Go version: `go 1.26.2`

## Core keep set for MVP

- CLI non-interactive path: `main.go`, `internal/cmd/run.go`
- Agent/runtime: `internal/agent/`
- Config and provider resolution: `internal/config/`
- Persistence: `internal/db/`, `internal/session/`, `internal/message/`, `internal/history/`, `internal/filetracker/`
- Permissions: `internal/permission/`
- Shell runtime: `internal/shell/`
- File and search tools:
  - `internal/agent/tools/view.go`
  - `internal/agent/tools/grep.go`
  - `internal/agent/tools/glob.go`
  - `internal/agent/tools/ls.go`
  - `internal/agent/tools/edit.go`
  - `internal/agent/tools/multiedit.go`
  - `internal/agent/tools/write.go`
  - `internal/diff/`

## Defer set for MVP

- TUI stack: `internal/ui/`
- LSP stack: `internal/lsp/`
- MCP stack: `internal/agent/tools/mcp/`
- Client/server/API stack: `internal/client/`, `internal/server/`, `internal/backend/`, `internal/proto/`
- Login, stats, and broader ecosystem commands

## High-risk dependencies

- `github.com/aymanbagabas/go-nativeclipboard`
  - `internal/ui/model/clipboard_supported.go` originally included `linux/riscv64`
  - pulls in desktop/X11 behavior that is not core to the MVP
- `github.com/gen2brain/beeep`
  - used by `internal/ui/notification/native.go`
  - desktop notification path with no MVP value on a headless board
- `modernc.org/sqlite`
  - important but positive signal: `internal/db/connect_modernc.go` explicitly includes `linux/riscv64`
  - still worth runtime validation because it is central to session persistence

## Medium-risk dependencies

- `charm.land/bubbletea/v2`
- `charm.land/lipgloss/v2`
- `github.com/nxadm/tail`
- transitive Linux desktop and file-watch chain:
  - `github.com/fsnotify/fsnotify`
  - `github.com/esiqveland/notify`
  - `github.com/godbus/dbus/v5`
  - `github.com/tadvi/systray`

## Likely-safe core dependencies

- `mvdan.cc/sh/v3`
- `mvdan.cc/sh/moreinterp`
- `github.com/bmatcuk/doublestar/v4`
- `github.com/charlievieth/fastwalk`
- `github.com/modelcontextprotocol/go-sdk`
- `github.com/go-git/go-git/v5`
- remote provider stack through `charm.land/fantasy`

## Key takeaways

- `Crush` is not blocked at compile time on `linux/riscv64`.
- The main risk concentration is not provider/session/file tools; it is UI-adjacent clipboard, notification, and interaction layers.
- The MVP should isolate headless runtime behavior from the full TUI dependency chain as early as possible.
