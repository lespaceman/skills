# drisp reference

Verify version-sensitive claims against the installed build before relying on them:

```bash
drisp --version && drisp exec --help
```

## What it is

`@drisp/cli` on npm; aliases `athena` and `athena-flow`. Repo `drisplabs/cli`. Docs
`athenaflow.in/docs`. The older `lespaceman/athena-flow-cli` is a dead brand.

It spawns `claude -p … --output-format stream-json`, forwards Claude Code hook events over a local
Unix socket, and adds versioned workflows, a marketplace, SQLite session persistence, and terminal
observability. The harness is pluggable (`claude-code` or Codex).

## Commands

| Command | Purpose |
| --- | --- |
| `drisp` | Interactive TUI session in the current directory |
| `drisp resume [id]` / `drisp sessions` | Pick up past sessions |
| `drisp exec "<prompt>"` | Headless run, for CI and scripts |
| `drisp workflow install\|list\|search\|remove\|upgrade\|use\|status` | Manage workflows |
| `drisp marketplace add\|refresh\|remove\|list` | Manage workflow sources |
| `drisp mcp` / `drisp skill` | Personal capabilities layered onto runs |
| `drisp channel telegram configure` | Notification channels |
| `drisp dashboard pair\|status\|daemon\|unpair` | Dashboard pairing |
| `drisp doctor` | Probe the claude binary and setup |

### exec flags

`--json` (JSONL lifecycle events) · `--output-last-message <file>` · `--ephemeral` ·
`--continue[=id]` · `--timeout-ms` · `--workflow <name>` (per-run override) · `--dry-run` (print the
resolved bootstrap without running).

Exit codes: `0` ok · `2` usage · `3` bootstrap · `4` runtime · `5` policy · `6` timeout ·
`7` output-write.

## Config

Merge order: `~/.config/athena/config.json` → repo `.athena/config.json` → CLI flags.

Global keys seen in practice: `harness`, `activeWorkflow`, `channels`, `mcpServers`, `skills`,
`theme`. A per-repo `.athena/config.json` is the right place to pin a repo to a different workflow
and model:

```json
{ "activeWorkflow": "playwright-automation", "model": "opus" }
```

**Isolation presets:** `strict` (default — the spawned Claude gets `--setting-sources ''` and no MCP
servers), `minimal`, `permissive`. Strict isolation is why a run may not see MCP tools you have
configured in your own session.

## On-disk layout

| Path | Contents |
| --- | --- |
| `~/.config/athena/workflows/<name>/workflow.md` | **The binding state machine.** Read this, don't reconstruct it. |
| `~/.config/athena/workflows/<name>/workflow.json` | Loop config (`maxIterations`) and pinned plugin refs |
| `~/.config/athena/plugin-packages/<owner>/<marketplace>/<plugin>/<ver>/` | Unpacked plugin skills |
| `<repo>/.athena/<session_id>/tracker.md` | The run's continuity artifact |
| `<repo>/.athena/<session_id>/logs/`, `scratch/` | Gate run logs and probe scripts |

`.athena/` is scratch and should be gitignored — but it is real forensic evidence of past runs, so
grep it before concluding a previous run left nothing behind. It accumulates: one repo reached 137
session directories.

## The phase machine

`fullstack-engineering` runs ten phases:

**1 Intake → 2 Orientation → 3 Problem Definition → 4 Design → 5 Implementation Plan → 6 Build →
7 Verification → 8 Review → 9 Delivery → 10 Handoff**

Two mechanisms enforce it:

- **Turn Protocol** — a status block emitted *before any action* each turn:
  `PHASE / GOAL / LAST GATE CLEARED / SKILLS LOADED THIS TURN / NEXT ACTION / BLOCKER / LAST VERIFICATION`.
  No block emitted → not allowed to edit files, run commands, or load skills that turn.
- **Phase Transition Rule** — before entering phase N+1, emit
  `GATE <phase N>: PASS — artifact: <where it lives durably> — evidence: <what proves it>`.
  Evidence is observable output, never "I believe" or "it should".

**Phases 7 (Verification) and 8 (Review) are hard gates** — never skipped, deferred, or self-waived;
only the user waives, and only a specific named gate. A passing unit suite alone does not clear
Phase 7 for user-visible work — that needs browser or product evidence. Nothing reaches Delivery,
and no issue moves to Done, until both pass or are waived.

**Reset Rules** send you *back* a phase when evidence invalidates the path: new scope → Problem
Definition; new public contract → Design; verification reveals a different bug → Problem Definition.
On a shortcut path, a reset naming a skipped phase promotes the run to the full path.

Shortcuts exist (read-only request stops early; a tiny local edit runs 1→2→6→7→8→9), but a skip
still requires its gate line citing the existing artifact, and production-sensitive work gets no
shortcuts at all.

## Terminal markers

| Marker | Meaning |
| --- | --- |
| `<!-- WORKFLOW_COMPLETE -->` | All work done and verified. Ends the run. |
| `<!-- WORKFLOW_BLOCKED -->` / `<!-- WORKFLOW_BLOCKED: reason -->` | Cannot proceed without external intervention. Always give a reason when you can. |

A workflow may configure its own markers. Only the **last non-empty line** of the tracker is
authoritative, so marker-like text in notes or quoted instructions earlier in the file is ignored.

## Version hazards

- The published README has documented `exec` flags that the installed build rejects with exit 2.
  Trust `--help` over the README.
- The `athena/cli` **source repo** documents a needs-attention model (`awaiting_attention`, retry and
  nudge caps, `WORKFLOW_BLOCKED` as a resumable suspend). Confirm it exists in the installed build
  before designing around it — in v0.5.26 it does not, and `WORKFLOW_BLOCKED` is a plain block:

  ```bash
  grep -rl "awaiting_attention" "$(npm root -g)/@drisp/cli/dist"
  ```
