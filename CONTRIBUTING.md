# Contributing

Thanks for helping improve these skills. Bug reports, fixes to existing skills, and new skills are all welcome.

## Reporting problems

Open an [issue](https://github.com/lespaceman/skills/issues) and include:

- the skill name
- the agent and version you used (for example Claude Code 2.x or Codex)
- what you asked the agent to do, what happened, and what you expected

## Making changes

1. Fork the repo and create a branch.
2. Edit or add a skill under `skills/<skill-name>/`.
3. Run the validator (see below).
4. Install your local copy to try it: `npx skills add ./ --skill <skill-name>`.
5. Open a pull request describing the change and how you tested it.

## Skill rules

Every skill must follow the [Agent Skills specification](https://agentskills.io/specification).

**Folder and name**
- The folder name and the `name` field in `SKILL.md` must match.
- Names are lowercase letters, digits, and hyphens, at most 64 characters.
- Names must be unique across the repo. When two frameworks need the same skill, prefix it (`playwright-fix-flaky-tests`, `robot-fix-flaky-tests`).

**Frontmatter**
- Allowed keys: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`.
- `description` is at most 1024 characters.
- Put client-specific keys such as `user-invocable` or `argument-hint` in `agents/claude.yaml`, not in `SKILL.md`.
- `allowed-tools` is optional. If you set it, list every tool explicitly.

**Descriptions**

Agents decide whether to load a skill from its description alone, so write it for that:
- say what the skill does and when to use it
- include the phrases a user would actually say ("flaky test", "add Playwright tests")
- say what the skill does not do and which skill to use instead

**Self-contained**
- Everything a skill needs must live inside its folder. Do not reference files in other skills or outside the repo by path.
- Refer to other skills by name (`generate-test-cases`), not by path.
- Keep `SKILL.md` focused and move long reference material into `references/`, so it loads only when needed.
- If a skill needs an MCP server or CLI, say so near the top of `SKILL.md` and add it to the Requirements table in the README.
- Refer to MCP tools by their server name (`mcp__drisp-browser__*`), not by plugin-specific prefixes.

**README**

When you add, rename, or remove a skill, update the tables in `README.md`.

## Validating

```shell
python3 -m venv .venv
.venv/bin/pip install skills-ref
scripts/validate.sh
```

CI runs the same check on every push and pull request.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
