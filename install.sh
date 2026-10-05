#!/usr/bin/env bash
# Install this collection for installed Claude Code and Codex CLIs.
#
#   ./install.sh                                   # everything
#   ./install.sh find-skills implement-paper       # just these (third-party or custom)
#
# Third-party skills come from skills-lock.json via the `skills` CLI (npx skills),
# installed globally so they're active in every project.
# Custom skills (./custom/*) are symlinked into each agent's personal skills
# directory so edits stay live.
# Shared global instructions are linked to each installed agent's expected path.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

want=("$@")   # no args = install all
wanted() {
  [ ${#want[@]} -eq 0 ] && return 0
  local w; for w in "${want[@]}"; do [ "$w" = "$1" ] && return 0; done
  return 1
}

link_instructions() {
  local source="$1" target="$2" backup suffix=0
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    backup="$target.backup"
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      suffix=$((suffix + 1))
      backup="$target.backup.$suffix"
    done
    mv "$target" "$backup"
    echo "backed up $target -> $backup"
  fi
  ln -s "$source" "$target"
  echo "linked $source -> $target"
}

install_agents=()
destinations=()
if command -v claude >/dev/null 2>&1; then
  install_agents+=(claude-code)
  destinations+=("${CLAUDE_HOME:-$HOME/.claude}/skills")
fi
if command -v codex >/dev/null 2>&1; then
  install_agents+=(codex)
  destinations+=("$HOME/.agents/skills")
fi

# 1. Third-party skills from the lockfile (installed globally).
if [ ${#install_agents[@]} -gt 0 ]; then
  while IFS=$'\t' read -r name pkg; do
    wanted "$name" || continue
    echo "installing $name  ($pkg)"
    npx --yes skills@latest add "$pkg" -g -y -a "${install_agents[@]}" >/dev/null </dev/null
  done < <(jq -r '.skills | to_entries[] | "\(.key)\t\(.value.source)@\(.key)"' skills-lock.json)
fi

# 2. Custom skills symlinked into each installed agent's skills directory.
for d in custom/*/; do
  [ -e "$d" ] || continue
  name="$(basename "$d")"
  wanted "$name" || continue
  for dest in "${destinations[@]}"; do
    mkdir -p "$dest"
    target="$dest/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skipping $target: an existing file or directory is not a symlink" >&2
      continue
    fi
    ln -sfn "$PWD/${d%/}" "$target"
    echo "linked custom/$name -> $target"
  done
done

# 3. Shared global instructions (full install only).
if [ ${#want[@]} -eq 0 ]; then
  instructions="$PWD/global/agent-instructions.md"
  if command -v claude >/dev/null 2>&1; then
    link_instructions "$instructions" "${CLAUDE_HOME:-$HOME/.claude}/CLAUDE.md"
  fi
  if command -v codex >/dev/null 2>&1; then
    link_instructions "$instructions" "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
  fi
fi

# 4. Hooks symlinked into ~/.claude/hooks and registered in settings.json
#    (full install only). Registration is idempotent: it matches on the command
#    string, so re-running never stacks a second copy, and an unrelated
#    PreToolUse hook already in the file is left alone.
if [ ${#want[@]} -eq 0 ] && command -v claude >/dev/null 2>&1; then
  home="${CLAUDE_HOME:-$HOME/.claude}"
  mkdir -p "$home/hooks"
  for h in hooks/*.sh; do
    [ -e "$h" ] || continue
    ln -sfn "$PWD/$h" "$home/hooks/$(basename "$h")"
    echo "linked $h"
  done
  settings="$home/settings.json"
  [ -f "$settings" ] || echo '{}' > "$settings"
  cmd='~/.claude/hooks/no-ai-attribution.sh'
  jq --arg c "$cmd" '
    .hooks.PreToolUse //= []
    | if any(.hooks.PreToolUse[]; (.hooks // [])[].command == $c) then .
      else .hooks.PreToolUse += [{matcher: "Bash", hooks: [{type: "command", command: $c, timeout: 10}]}] end
  ' "$settings" > "$settings.tmp" && mv "$settings.tmp" "$settings"
  echo "registered no-ai-attribution PreToolUse hook"
fi

# 5. Plugins (full install only; subset installs are skills-only).
if [ ${#want[@]} -eq 0 ] && command -v claude >/dev/null 2>&1 && [ -x ./plugins.sh ]; then ./plugins.sh; fi

echo "Done. Restart Claude Code or Codex if new skills do not appear."
