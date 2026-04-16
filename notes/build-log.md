# Build Log

## 2026-04-15

### Local Windows workspace

- `git` available locally
- `go` not installed locally
- Docker client available, but Docker Linux engine was not running, so local containerized build was unavailable

### Target host

- Host alias: `pi-board`
- Resolved host: `pi@192.168.137.223`
- Architecture: `riscv64`
- Kernel: `Linux spacemit-k1-x-MUSE-Pi-Pro-board 6.6.63`

### Remote toolchain

- Default toolchain: `go version go1.22.2 linux/riscv64`
- `GOTOOLCHAIN=auto` upgraded build execution to `go1.26.2`

### Build attempts

1. `CGO_ENABLED=0 GOEXPERIMENT=greenteagc GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build ./...`
   - Result: failed
   - Failure: `go: unknown GOEXPERIMENT greenteagc`
   - Conclusion: `greenteagc` is currently stale for this toolchain path and must not be treated as required for MVP validation

2. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build ./...`
   - Result: passed
   - Conclusion: full package compilation succeeds on the native `riscv64` board

3. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -o crush-riscv64 .`
   - Result: built an ELF binary
   - Runtime issue: interpreter path defaulted to `/lib/ld.so.1`, which does not exist on the target

4. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-riscv64-run .`
   - Result: passed
   - Conclusion: runnable binary produced for this board image

5. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -tags headless ./...`
   - Result: passed
   - Conclusion: the first-pass headless compile surface is valid

6. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -tags headless -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-headless-riscv64 .`
   - Result: passed
   - Conclusion: a runnable headless-target binary can be produced for this board image

7. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -tags headless -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-headless-v3 .`
   - Result: passed
   - Conclusion: later headless iterations still build after further dependency trimming

8. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -tags headless -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-headless-v4 .`
   - Result: passed
   - Conclusion: headless compile surface remains healthy after removing more non-core cmd files from the build

9. `CGO_ENABLED=0 GOTOOLCHAIN=auto GOOS=linux GOARCH=riscv64 go build -tags headless -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-headless-v5 .`
   - Result: passed
   - Conclusion: headless compile surface remains healthy after removing `logs` and `update-providers` from the build

10. `/home/pi/crush-riscv64/build-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-v6`
   - Result: passed
   - Conclusion: dedicated headless wrapper script now produces a static `riscv64` binary

11. `/home/pi/crush-riscv64/release-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-release /home/pi/crush-riscv64/dist`
   - Result: passed
   - Conclusion: release bundle generation now works end-to-end, including tarball output

12. Release bundle contents validated
   - Result: passed
   - Evidence:
     - bundle directory exists
     - bundle tarball exists
     - `manifest.json` exists in the bundle

13. `/home/pi/crush-riscv64/verify-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-verify /home/pi/crush-riscv64/dist HEADLESS_VERIFY_OK`
   - Result: passed
   - Conclusion: one-command verification now reproduces build, package, and provider-backed smoke on the target

14. `/home/pi/crush-riscv64/run-headless-pipeline.sh /home/pi/crush-riscv64/forks/crush crush-headless-pipeline /home/pi/crush-riscv64/dist HEADLESS_PIPELINE_OK`
   - Result: passed
   - Conclusion: pipeline wrapper now reproduces release bundle generation, notes generation, smoke verification, and persistent pipeline logging

### Current conclusion

- `Crush` can be compiled on native `riscv64 Linux`.
- A board-specific interpreter override is currently needed to get an executable binary on this image.
- The next blockers are scope-reduction and dependency-isolation work, not base compilation.
