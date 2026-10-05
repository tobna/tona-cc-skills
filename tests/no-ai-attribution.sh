#!/usr/bin/env bash
# Feeds commands to hooks/no-ai-attribution.sh and checks each is allowed or denied.
set -uo pipefail
hook="$(dirname "$(readlink -f "$0")")/../hooks/no-ai-attribution.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
printf 'Fix it\n\nCo-Authored-By: Anthropic\n' >"$tmp/bad.txt"
printf 'Fix it\n' >"$tmp/good.txt"

fail=0
check() { # check allow|deny COMMAND
  local out got=allow
  out=$(jq -n --arg c "$2" --arg d "$tmp" '{cwd: $d, tool_input: {command: $c}}' | "$hook")
  [ -n "$out" ] && got=deny
  [ "$got" = "$1" ] || { printf 'FAIL want %s: %s\n' "$1" "$2"; fail=1; }
}

# Paths and other non-message text may name anything.
check allow 'ls ~/.claude'
check allow 'git add CLAUDE.md AGENTS.md && git commit -m "Update instructions"'
check allow 'cd ~/.codex && git commit -am "tidy"'
check allow 'git commit --amend --no-edit CLAUDE.md'
check allow 'git -C ~/.claude commit -m "tidy" -- CLAUDE.md'
check allow 'gh pr create -t "Fix" -b "Body" -R me/claude-tools'
check allow $'cat > CLAUDE.md <<\'EOF\'\nClaude rules\nEOF\ngit add CLAUDE.md && git commit -m "Add rules"'
check allow $'git add CLAUDE.md && git commit -m "$(cat <<\'EOF\'\nAdd rules\n\nLonger body.\nEOF\n)"'
check allow 'git add CLAUDE.md && git commit -F good.txt'
check allow 'git commit -m "Fix GPT partition table"'

# The message itself is checked literally.
check deny 'git commit -m "Update CLAUDE.md"'
check deny $'git commit -m "$(cat <<\'EOF\'\nFix it\n\nCo-Authored-By: Claude <noreply@anthropic.com>\nEOF\n)"'
check deny $'git commit -F - <<\'EOF\'\nFix it\n\nCo-authored-by: Codex\nEOF'
check deny 'git commit -m "tidy" --trailer "Assisted-by: GPT-5.1"'
check deny 'git commit -am"Generated with ChatGPT"'
check deny 'git commit --author="Bot <noreply@openai.com>" -m "tidy"'
check deny 'git commit -F bad.txt'
check deny 'git commit -F - <<< "via gpt4"'
check deny $'gh pr create --title "Fix" --body "$(cat <<\'EOF\'\nGenerated with gpt-4o\nEOF\n)"'

# Message not pinned down: falls back to the whole command.
check deny 'echo "Co-Authored-By: Claude" | git commit -F -'
check deny 'git add CLAUDE.md && git commit -F not-written-yet.txt'
check deny $'git commit -m $(cat <<\'EOF\'\nby Claude\nEOF\n)'
check deny 'git commit -m "unbalanced by claude'

[ "$fail" = 0 ] && echo "all passed"
exit "$fail"
