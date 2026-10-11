# skills

Agent Skills by [lespaceman](https://github.com/lespaceman), following the [Agent Skills](https://agentskills.io) folder layout (`skills/<name>/SKILL.md`).

## Install

```shell
npx skills add lespaceman/skills                    # pick interactively
npx skills add lespaceman/skills --skill drisp-browser
npx skills add lespaceman/skills --list             # list available skills
```

## Skills

| Skill | Description |
|-------|-------------|
| [`add-playwright-tests`](skills/add-playwright-tests) | THE DEFAULT ENTRY POINT for the Playwright execution layer in the split testing suite. |
| [`add-robot-tests`](skills/add-robot-tests) | THE DEFAULT ENTRY POINT for the Robot Framework execution layer in the split testing suite. |
| [`capture-feature-evidence`](skills/capture-feature-evidence) | Deeply explore a live app feature or a single mapped sub-feature and capture grounded evidence for downstream planning in `docs/qa/exploration-report.md` or a scoped file under `docs/qa/exploration/`. |
| [`define-regression-scope`](skills/define-regression-scope) | Use to define impact-based regression scope for a release, hotfix, changed area, or risky feature: decide what should be rerun beyond smoke, why it belongs in regression, and how deep each area should go. |
| [`define-smoke-scope`](skills/define-smoke-scope) | Use to define the smallest high-signal confidence slice for a product, feature, or release. |
| [`drisp-browser`](skills/drisp-browser) | Drive a real browser against a live or staging website with the Drisp Browser (@drisp/browser-mcp) MCP tools (navigate, snapshot, click, type, find, get_form, screenshot). |
| [`drisp-guide`](skills/drisp-guide) | Operate the drisp CLI (@drisp/cli, aka athena/athena-flow) — launch and debug workflow runs, read exec exit codes, manage workflows and per-repo config — and follow the tracker + Turn Protocol contract correctly when running inside a drisp turn. |
| [`exploratory-test-writer`](skills/exploratory-test-writer) | Define an exploratory testing charter: frame what to investigate, why it matters, and which risk hypotheses to test before or alongside the shared testing workflow. |
| [`generate-test-cases`](skills/generate-test-cases) | Use to write detailed TC-ID test case specifications for a web app feature, not executable code. |
| [`linear`](skills/linear) | MUST load BEFORE reading from or writing to Linear and BEFORE any mcp__plugin_linear_linear__ tool call. |
| [`map-feature-scope`](skills/map-feature-scope) | Quickly map a broad product feature into concrete sub-features before deep exploration begins. |
| [`plan-test-coverage`](skills/plan-test-coverage) | Use before writing specs or executable tests to decide what coverage is needed first. |
| [`playwright-analyze-test-codebase`](skills/playwright-analyze-test-codebase) | Scans and reports on an existing Playwright test codebase. |
| [`playwright-fix-flaky-tests`](skills/playwright-fix-flaky-tests) | This skill should be used when a Playwright test is failing, flaky, timing out, or behaving inconsistently. |
| [`playwright-review-test-code`](skills/playwright-review-test-code) | Quality review of Playwright test code before final execution signoff. |
| [`review-robot-best-practices`](skills/review-robot-best-practices) | Use when reviewing Robot Framework and Python test automation code for best practices, maintainability, reliability, style, architecture, anti-patterns, or caveats. |
| [`review-test-cases`](skills/review-test-cases) | This skill should be used when a quality review of TC-ID test case specifications is needed before any framework-specific implementation begins. |
| [`robot-analyze-test-codebase`](skills/robot-analyze-test-codebase) | Use to inspect an existing Robot Framework + Browser library codebase before writing, reviewing, or fixing tests. |
| [`robot-fix-flaky-tests`](skills/robot-fix-flaky-tests) | This skill should be used when a Robot Framework test (Browser library) is failing, flaky, timing out, or behaving inconsistently. |
| [`robot-review-test-code`](skills/robot-review-test-code) | Quality review of Robot Framework test code before final execution signoff. |
| [`setup-engineering-workflow`](skills/setup-engineering-workflow) | Sets up the engineering workflow's per-repo context — an `## Agent skills` block in AGENTS.md/CLAUDE.md plus `docs/agents/` — capturing this repo's issue tracker (GitHub, GitLab, Linear, ClickUp, or local markdown), triage label vocabulary, domain doc layout, and delivery mode (merge / pr / local), and recording the workflow skill map derived from the installed plugins. |
| [`workflow-builder`](skills/workflow-builder) | Scaffold, create, revise, or review complete Athena workflow packages, including workflow.md orchestration docs, workflow.json definitions, Plugin Pins, marketplace registration, and validation. |
| [`write-robot-code`](skills/write-robot-code) | Use when writing, refactoring, or modifying Robot Framework E2E test code with the Browser library. |
| [`write-test-code`](skills/write-test-code) | This skill should be used when writing, refactoring, or modifying Playwright E2E test code. |

## Testing pipeline

The QA skills are layered and hand artifacts to each other:

1. **Explore**: `map-feature-scope` → `capture-feature-evidence`
2. **Plan**: `plan-test-coverage` → `generate-test-cases` → `review-test-cases`
3. **Execute** (pick one): `add-playwright-tests` or `add-robot-tests` and their `playwright-*` / `robot-*` helpers

Intent charters (`define-smoke-scope`, `define-regression-scope`, `exploratory-test-writer`) frame scope before execution.

Browser work relies on the Drisp Browser MCP server (`@drisp/browser-mcp`); `linear` relies on the Linear MCP server. Install those separately, because `npx skills add` copies skill files only.
