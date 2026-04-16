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


def run_once(bin_path: str, workdir: Path, expected: str, continue_last: bool) -> None:
    cmd = [bin_path, "--cwd", str(workdir)]
    if continue_last:
        cmd.append("--continue")

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


def main() -> int:
    bin_path = sys.argv[1] if len(sys.argv) > 1 else "./crush-interactive-riscv64"
    first_token = sys.argv[2] if len(sys.argv) > 2 else "INTERACTIVE_CONTINUE_A"
    second_token = sys.argv[3] if len(sys.argv) > 3 else "INTERACTIVE_CONTINUE_B"
    workdir = Path(sys.argv[4] if len(sys.argv) > 4 else "/tmp/interactive-chat-continuation")

    if not Path(bin_path).is_file():
        print(f"binary not found: {bin_path}", file=sys.stderr)
        return 1
    if not os.environ.get("DEEPSEEK_API_KEY"):
        print("DEEPSEEK_API_KEY is required for interactive continuation smoke.", file=sys.stderr)
        return 1

    if workdir.exists():
        shutil.rmtree(workdir)
    (workdir / ".crush").mkdir(parents=True, exist_ok=True)
    (workdir / "AGENTS.md").write_text("# interactive continuation smoke\n", encoding="utf-8")

    run_once(bin_path, workdir, first_token, continue_last=False)
    run_once(bin_path, workdir, second_token, continue_last=True)

    db_path = workdir / ".crush" / "crush.db"
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    sessions = cur.execute("select id, title from sessions order by created_at desc").fetchall()
    rows = cur.execute(
        "select session_id, role, parts from messages order by created_at desc limit 12"
    ).fetchall()
    conn.close()

    print(json.dumps({"sessions": sessions, "messages": rows}, ensure_ascii=False, indent=2))

    if len(sessions) != 1:
        print(f"expected exactly one session, found {len(sessions)}", file=sys.stderr)
        return 1

    texts = [parts for _, role, parts in rows if role == "assistant"]
    if not any(first_token in parts for parts in texts):
        print(f"missing assistant reply for first token: {first_token}", file=sys.stderr)
        return 1
    if not any(second_token in parts for parts in texts):
        print(f"missing assistant reply for second token: {second_token}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
