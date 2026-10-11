# lespaceman/skills

[![Validate skills](https://github.com/lespaceman/skills/actions/workflows/validate.yml/badge.svg)](https://github.com/lespaceman/skills/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A collection of [Agent Skills](https://agentskills.io) for QA test automation, browser-driven exploration, and engineering workflows. Each skill is a self-contained folder with a `SKILL.md` and any references it needs. They work in any agent that supports the Agent Skills format, including Claude Code, Codex, Cursor, and others supported by the [`skills` CLI](https://github.com/vercel-labs/skills).

## Install

```shell
npx skills add lespaceman/skills                         # choose skills interactively
npx skills add lespaceman/skills --skill drisp-browser   # install one skill
npx skills add lespaceman/skills --list                  # list skills without installing
npx skills add lespaceman/skills -g                      # install for your user, not just this project
```

Skills that depend on an MCP server say so in their `SKILL.md`. `npx skills add` copies only the skill files, so install those MCP servers separately (see [Requirements](#requirements)).

## Skills

### Browser and runtime

| Skill | What it does |
|-------|--------------|
| [`drisp-browser`](skills/drisp-browser) | Drive a real browser against a live site: navigate, click, fill forms, upload files, take screenshots, extract selectors. |
| [`drisp-guide`](skills/drisp-guide) | Operate the `drisp` CLI: launch and debug workflow runs, read exit codes, and follow the tracker and Turn Protocol contract. |

### Exploration and test planning

| Skill | What it does |
|-------|--------------|
| [`map-feature-scope`](skills/map-feature-scope) | Break a broad feature into bounded sub-features before deep exploration. |
| [`capture-feature-evidence`](skills/capture-feature-evidence) | Explore a live feature and record grounded evidence for test planning. |
| [`plan-test-coverage`](skills/plan-test-coverage) | Decide what coverage a feature needs and in what order, before writing specs. |
| [`generate-test-cases`](skills/generate-test-cases) | Write TC-ID test case specifications (not code) from exploration evidence. |
| [`review-test-cases`](skills/review-test-cases) | Review TC-ID specs for gaps, duplication, and weak assertions before automation. |

### Test intent charters

| Skill | What it does |
|-------|--------------|
| [`define-smoke-scope`](skills/define-smoke-scope) | Define the smallest high-signal smoke slice for a product, feature, or release. |
| [`define-regression-scope`](skills/define-regression-scope) | Define impact-based regression scope for a release, hotfix, or changed area. |
| [`exploratory-test-writer`](skills/exploratory-test-writer) | Write an exploratory testing charter: what to investigate, why, and which risks to probe. |

### Playwright

| Skill | What it does |
|-------|--------------|
| [`add-playwright-tests`](skills/add-playwright-tests) | End-to-end entry point: analyze, write, review, and run Playwright tests for a feature. |
| [`playwright-analyze-test-codebase`](skills/playwright-analyze-test-codebase) | Report on an existing Playwright setup: config, fixtures, page objects, conventions. |
| [`write-test-code`](skills/write-test-code) | Write or refactor Playwright tests from TC-ID specs. |
| [`playwright-review-test-code`](skills/playwright-review-test-code) | Review Playwright test code for brittle selectors, bad waits, and missing teardown. |
| [`playwright-fix-flaky-tests`](skills/playwright-fix-flaky-tests) | Root-cause and fix flaky, failing, or timing-out Playwright tests. |

### Robot Framework

| Skill | What it does |
|-------|--------------|
| [`add-robot-tests`](skills/add-robot-tests) | End-to-end entry point: analyze, write, review, and run Robot Framework (Browser library) tests. |
| [`robot-analyze-test-codebase`](skills/robot-analyze-test-codebase) | Report on an existing Robot setup and emit `docs/qa/conventions.yaml`. |
| [`write-robot-code`](skills/write-robot-code) | Write or refactor `.robot` suites from TC-ID specs. |
| [`robot-review-test-code`](skills/robot-review-test-code) | Review Robot test code before execution signoff. |
| [`review-robot-best-practices`](skills/review-robot-best-practices) | Review Robot Framework and Python automation code against best practices. |
| [`robot-fix-flaky-tests`](skills/robot-fix-flaky-tests) | Root-cause and fix flaky, failing, or timing-out Robot tests. |

### Engineering workflow

| Skill | What it does |
|-------|--------------|
| [`setup-engineering-workflow`](skills/setup-engineering-workflow) | Set up per-repo agent context: issue tracker, triage labels, domain docs, delivery mode. |
| [`linear`](skills/linear) | Work with Linear issues, projects, and cycles with consistent workflow discipline. |
| [`workflow-builder`](skills/workflow-builder) | Scaffold and review Athena workflow packages (`workflow.md`, `workflow.json`, plugin pins). |

## How the testing skills fit together

The QA skills are layered. Each stage writes files under `docs/qa/` that the next stage reads.

```text
map-feature-scope → capture-feature-evidence        explore the live product
        ↓
plan-test-coverage → generate-test-cases → review-test-cases        plan
        ↓
add-playwright-tests  or  add-robot-tests        implement, review, run
```

The intent charters (`define-smoke-scope`, `define-regression-scope`, `exploratory-test-writer`) decide what to test before that pipeline starts. Install the whole set for the full pipeline; installing only an execution skill leaves out the exploration and planning stages.

## Requirements

| Needed by | Requirement |
|-----------|-------------|
| `drisp-browser`, exploration skills, `add-*-tests` | [Drisp Browser MCP server](https://www.npmjs.com/package/@drisp/browser-mcp): `claude mcp add drisp-browser -- npx @drisp/browser-mcp@latest` |
| `linear` | [Linear MCP server](https://linear.app/docs/mcp) registered as `linear` |
| `drisp-guide` | The [`drisp` CLI](https://www.npmjs.com/package/@drisp/cli) |
| Playwright skills | Node.js and `@playwright/test` in the target project |
| Robot skills | Python, Robot Framework, and `robotframework-browser` in the target project |

## Repository layout

```text
skills/
  <skill-name>/
    SKILL.md            # required: frontmatter + instructions
    references/         # optional: docs loaded on demand
    scripts/            # optional: helper scripts
    agents/             # optional: client-specific metadata (claude.yaml, openai.yaml)
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Run `scripts/validate.sh` before opening a pull request.

## License

[MIT](LICENSE)
