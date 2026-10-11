#!/usr/bin/env bash
# Validate every skill against the Agent Skills spec and repo conventions.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

if command -v agentskills >/dev/null 2>&1; then
  validator="agentskills"
elif [ -x .venv/bin/agentskills ]; then
  validator=".venv/bin/agentskills"
else
  echo "agentskills not found. Install it with: pip install skills-ref" >&2
  exit 1
fi

failed=0
for dir in skills/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"

  if ! out="$("$validator" validate "$dir" 2>&1)"; then
    echo "FAIL $name"
    echo "$out" | sed 's/^/  /'
    failed=1
    continue
  fi

  if ! grep -q "\[\`$name\`\](skills/$name)" README.md; then
    echo "FAIL $name: missing from README.md skills table"
    failed=1
    continue
  fi

  echo "ok   $name"
done

exit "$failed"
