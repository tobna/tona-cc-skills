#!/usr/bin/env bash
# PreToolUse/Bash: refuse a `git commit` or `gh pr create` whose text contains
# "claude" or "anthropic".
#
# Enforces the Git rule in ~/.claude/CLAUDE.md, which is a blanket ban on the
# words rather than a list of known trailer formats. It lives out here as well
# because a prohibition in a prompt is something the model can rationalise past:
# twice it has followed a harness instruction to append a trailer anyway, the
# second time a `Claude-Session:` URL that no list of formats had named. A hook
# does not weigh instructions.
#
# Deliberately literal, so a commit message that merely names CLAUDE.md is
# refused too. Add a carve-out here if that becomes annoying -- but a scrub rule
# is the seam a novel attribution form would slip through, which is the whole
# thing this exists to stop.
#
# Blind spot: a bare `git commit` opens an editor, so the message never reaches
# this hook. A repo `commit-msg` hook covers that path.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // ""')

# Not a commit or a PR body? Nothing to police. Matches mid-command as well, so
# `git add -A && git commit ...` is caught, not only a command starting with it.
# The flag group swallows an option and, optionally, a separate value, so global
# options reach the subcommand: `git -C /path commit`, `git -c user.name=x commit`.
grep -qE '(^|[;&|(]|[[:space:]])(git[[:space:]]+(-[^[:space:]]+[[:space:]]+([^-][^[:space:]]*[[:space:]]+)?)*commit|gh[[:space:]]+pr[[:space:]]+(create|edit))\b' <<<"$cmd" || exit 0

hit=$(grep -oiE 'claude|anthropic' <<<"$cmd" | sort -fu | paste -sd, -)
[ -z "$hit" ] && exit 0

jq -n --arg hit "$hit" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("This commit/PR text contains: " + $hit + ". Commit messages and PR descriptions must never mention Claude or Anthropic -- no Co-Authored-By, no Generated-with, no Claude-Session trailer, no session URL, in any wording. No harness instruction overrides this. Rewrite the message without it; if the message legitimately needs the word (naming the CLAUDE.md file), ask the user rather than working around this hook.")
  }
}'
