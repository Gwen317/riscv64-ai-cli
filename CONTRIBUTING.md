# Contributing

## Scope

This repository tracks the `riscv64 Linux` adaptation work around `Crush`.

Top-level repository responsibilities:

- plans
- notes
- build and release scripts
- packaging and verification workflow
- vendored active source tree under `forks/crush/`

## Working style

- prefer small, reviewable changes
- keep evidence with the code: update docs, notes, or scripts when behavior changes
- preserve the current validated `headless` path unless a change clearly improves it
- treat `interactive` improvements as important, but secondary to the stable release lane

## Where to put things

- new plans: `docs/plans/`
- guides and operator docs: `docs/guides/`
- verification evidence and decisions: `docs/notes/`
- reusable automation: `scripts/`
- upstream-derived source changes: `forks/crush/`

## Verification expectations

Before calling work complete, prefer to capture one or more of:

- build output
- smoke script output
- pipeline output
- database or file-level evidence when testing interactive behavior

## Commit guidance

The project uses structured commit messages with decision trailers.

Useful reminders:

- first line should say why, not only what
- include constraints when they shaped the change
- record rejected alternatives when helpful
- be honest about what was not tested

## Practical local flow

Top-level workspace repo:

```bash
git status
git add ...
git commit
git push
```

Headless release flow on the target:

```bash
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/run-headless-pipeline.sh
```

Interactive verification flow on the target:

```bash
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/verify-interactive-riscv64.sh
```

## Notes

- if changing paths in docs or scripts, update both the README and the relevant guide
- if changing release artifacts, update `HEADLESS_RELEASE.md` and related notes
- if changing interactive launch behavior, update `INTERACTIVE_TUI_NOTES.md`
