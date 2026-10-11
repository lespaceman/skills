#!/usr/bin/env bash
# Mirror a drisp tracker from a git worktree back to the canonical checkout.
#
# drisp anchors the tracker to the directory the run was launched from. When work moves into a
# worktree, the runner keeps reading the ORIGINAL path, so an un-mirrored tracker silently loses
# the turn's state. Run this after EVERY tracker edit.
#
# Usage: mirror-tracker.sh [session-id]
#   session-id is inferred when the worktree's .athena/ holds exactly one session directory.

set -euo pipefail

die() { printf 'mirror-tracker: %s\n' "$1" >&2; exit 1; }

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git work tree"

worktree_root=$(git rev-parse --show-toplevel)
# --git-common-dir points at the MAIN checkout's .git even from inside a worktree.
common_dir=$(cd "$worktree_root" && cd "$(git rev-parse --git-common-dir)" && pwd)
canonical_root=$(dirname "$common_dir")

if [ "$canonical_root" = "$worktree_root" ]; then
  echo "Already in the canonical checkout ($canonical_root) — nothing to mirror."
  exit 0
fi

session=${1:-}
if [ -z "$session" ]; then
  shopt -s nullglob
  candidates=("$worktree_root"/.athena/*/)
  shopt -u nullglob
  [ ${#candidates[@]} -eq 0 ] && die "no session directory under $worktree_root/.athena — pass a session id"
  [ ${#candidates[@]} -gt 1 ] && die "${#candidates[@]} session directories found — pass the session id explicitly"
  session=$(basename "${candidates[0]}")
fi

src="$worktree_root/.athena/$session/tracker.md"
dest="$canonical_root/.athena/$session/tracker.md"

[ -f "$src" ] || die "no tracker at $src"

mkdir -p "$(dirname "$dest")"
cp "$src" "$dest"

# The copy is the whole point — prove it landed rather than trusting cp's exit code.
if cmp -s "$src" "$dest"; then
  echo "Mirrored $session -> $dest"
else
  die "mirror verification FAILED: $dest differs from $src (is the canonical path read-only?)"
fi
