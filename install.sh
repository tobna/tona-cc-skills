#!/usr/bin/env bash
# Install this collection into ~/.claude (and any other detected agents).
#
#   ./install.sh                                   # everything
#   ./install.sh find-skills implement-paper       # just these (third-party or custom)
#
# Third-party skills come from skills-lock.json via the `skills` CLI (npx skills),
# installed globally so they're active in every project.
# Custom skills (./custom/*) are symlinked into ~/.claude/skills so edits stay live.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

want=("$@")   # no args = install all
wanted() {
  [ ${#want[@]} -eq 0 ] && return 0
  local w; for w in "${want[@]}"; do [ "$w" = "$1" ] && return 0; done
  return 1
}

# 1. Third-party skills from the lockfile (installed globally).
while IFS=$'\t' read -r name pkg; do
  wanted "$name" || continue
  echo "installing $name  ($pkg)"
  npx --yes skills@latest add "$pkg" -g -y >/dev/null </dev/null
done < <(jq -r '.skills | to_entries[] | "\(.key)\t\(.value.source)@\(.key)"' skills-lock.json)

# 2. Custom skills symlinked into ~/.claude/skills.
dest="${CLAUDE_HOME:-$HOME/.claude}/skills"; mkdir -p "$dest"
for d in custom/*/; do
  [ -e "$d" ] || continue
  name="$(basename "$d")"
  wanted "$name" || continue
  ln -sfn "$PWD/${d%/}" "$dest/$name"
  echo "linked custom/$name"
done

echo "Done. Restart Claude Code to pick up new skills."
