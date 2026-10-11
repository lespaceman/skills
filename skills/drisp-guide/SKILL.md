---
name: drisp-guide
description: Operate the drisp CLI (@drisp/cli, aka athena/athena-flow) — launch and debug workflow runs, read exec exit codes, manage workflows and per-repo config — and follow the tracker + Turn Protocol contract correctly when running inside a drisp turn. Use when the user mentions drisp, athena-flow, `drisp exec`, a workflow tracker, `.athena/`, WORKFLOW_COMPLETE / WORKFLOW_BLOCKED, TRACKER_SKELETON, or when a session is driving repo work under a drisp workflow.
---

# drisp

`drisp` is a workflow runtime that **wraps Claude Code**. It spawns `claude -p`, forwards hook
events over a local socket, and drives a versioned workflow as a state machine. The unit of
continuity is a **tracker file**, not the conversation.

Two situations. Find yours first — the failure modes are different.

## A — You are operating drisp (launching or debugging a run)

```bash
drisp                          # interactive TUI in the current directory
drisp exec "<prompt>" --json   # headless; JSONL lifecycle events
drisp workflow list            # what is installed; `use <name>` switches the active one
drisp doctor                   # probes the claude binary
```

Config merges **global → project → flags**: `~/.config/athena/config.json`, then the repo's
`.athena/config.json` (pin `activeWorkflow` and `model` per repo here), then CLI flags.

**Debugging a run that "failed":**

| Symptom | What it actually means |
| --- | --- |
| `exec` exits **4**, "tracker skeleton was never replaced" | The model likely answered fine — it just never wrote the tracker. Read the answer from the `message.complete` JSONL event. Common on trivial prompts. |
| Exit **2**, "Unknown flags" | The README is ahead of the installed build. Check `drisp exec --help` before trusting docs. |
| Run ended early and nothing resumes it | A terminal marker was written prematurely. There is **no automatic recovery** — see below. |

Exit codes: `0` ok · `2` usage · `3` bootstrap · `4` runtime · `5` policy · `6` timeout · `7` output-write.

## B — You are running inside a drisp turn

The workflow's own text is already in your system prompt and is **binding, not advisory**. It tells
you the phases and gates. What it does *not* tell you is below — these are the things that have
actually broken real runs.

### The tracker contract

1. **Replace `<!-- TRACKER_SKELETON -->` before any domain work** on Turn 1. Even a three-line
   tracker (goal + "orienting") protects you if the turn dies during setup.
2. **Only the last non-empty line is authoritative.** You may discuss markers freely above it.
3. **A premature terminal marker ends the loop with no recovery.** Write `WORKFLOW_COMPLETE` only
   when every criterion is met; use `WORKFLOW_BLOCKED: <reason>` when you need a human.
4. **Write for a successor who remembers nothing.** Long turns compact repeatedly and the tracker is
   the only continuity. Record decisions, refuted hypotheses, corrections of your own earlier
   over-claims, and a "what the next turn does first" list — not just checkboxes.

### The worktree trap (read before creating a worktree)

drisp anchors the tracker to the directory it was launched from. If you then move work into a git
worktree, the runner keeps reading the **original** path.

```bash
scripts/mirror-tracker.sh            # after EVERY tracker edit, from inside the worktree
```

If the harness isolates the session and **refuses** writes back to the main checkout, the worktree is
unusable — the tracker contract outranks the worktree convention. Abandon it, work on a plain branch
in the main checkout, and record that decision in the tracker so a later turn does not retry the loop.

### Reset instead of restarting

When new input invalidates a finished run, **delete the `WORKFLOW_COMPLETE` marker** and reopen the
phase the new evidence lands in. Do not start a fresh session to redo settled work.

## Details

- Command surface, config, phase machine, and version hazards: [REFERENCE.md](REFERENCE.md)
- Read the active workflow's real text at `~/.config/athena/workflows/<name>/workflow.md` rather
  than paraphrasing it — it is versioned and changes.
