#!/usr/bin/env python3
from pathlib import Path
import json
import os
import pty
import select
import shutil
import sqlite3
import subprocess
import sys
import time


def main() -> int:
    bin_path = sys.argv[1] if len(sys.argv) > 1 else "./crush-interactive-riscv64"
    expected = sys.argv[2] if len(sys.argv) > 2 else "INTERACTIVE_SMOKE_OK"
    workdir = Path(sys.argv[3] if len(sys.argv) > 3 else "/tmp/interactive-chat-smoke")

    if not Path(bin_path).is_file():
        print(f"binary not found: {bin_path}", file=sys.stderr)
        return 1

    if not os.environ.get("DEEPSEEK_API_KEY"):
        print("DEEPSEEK_API_KEY is required for interactive smoke.", file=sys.stderr)
        return 1

    if workdir.exists():
        shutil.rmtree(workdir)
    (workdir / ".crush").mkdir(parents=True, exist_ok=True)
    (workdir / "AGENTS.md").write_text("# interactive smoke\n", encoding="utf-8")

    cmd = [bin_path, "--cwd", str(workdir)]
    env = os.environ.copy()
    env["TERM"] = env.get("TERM", "xterm-256color")

    master, slave = pty.openpty()
    proc = subprocess.Popen(cmd, stdin=slave, stdout=slave, stderr=slave, env=env, close_fds=True)
    os.close(slave)

    def drain(seconds: float) -> None:
        end = time.time() + seconds
        while time.time() < end:
            r, _, _ = select.select([master], [], [], 0.2)
            if master in r:
                try:
                    data = os.read(master, 65536)
                except OSError:
                    return
                if not data:
                    return

    drain(4.0)
    os.write(master, f"Reply with exactly: {expected}\r".encode("utf-8"))
    drain(12.0)

    proc.kill()
    proc.wait(timeout=3)

    db_path = workdir / ".crush" / "crush.db"
    deadline = time.time() + 5.0
    while time.time() < deadline and not db_path.exists():
        time.sleep(0.1)

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    deadline = time.time() + 5.0
    while time.time() < deadline:
        try:
            cur.execute("select count(*) from messages")
            break
        except sqlite3.OperationalError:
            time.sleep(0.1)

    rows = cur.execute(
        "select role, parts from messages order by created_at desc limit 6"
    ).fetchall()
    conn.close()

    print(json.dumps(rows, ensure_ascii=False, indent=2))

    assistant_texts = [parts for role, parts in rows if role == "assistant"]
    if not any(expected in parts for parts in assistant_texts):
        print(f"expected assistant response token not found: {expected}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
