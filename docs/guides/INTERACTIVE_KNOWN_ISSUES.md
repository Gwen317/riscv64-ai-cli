# Interactive Known Issues

## Current state

The interactive TUI is viable, but it is still secondary to the headless
delivery line.

## Known limits

- it requires a real terminal on both stdin and stdout
- non-tty startup should be treated as unsupported
- the most validated proof path is still scripted pseudo-tty automation, not
  long manual sessions
- some terminal capability probing still depends on the board image and SSH
  client behavior

## Operator guidance

- prefer a normal SSH terminal instead of redirected or piped launch
- if startup looks wrong, rebuild and relaunch from the board shell
- if auth fails, re-export `DEEPSEEK_API_KEY`
- if you need a reproducible proof, use the interactive smoke scripts before
  debugging visually

## Practical conclusion

The interactive path is good enough to use and iterate on, but the headless
path remains the safer release-oriented lane.

## What is already confirmed to work

- build on the target
- launch in a real TTY
- minimal prompt/response loop
- `--continue` reusing the same session
