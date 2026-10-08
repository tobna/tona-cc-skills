#!/usr/bin/env bash
# PreToolUse/Bash: refuse a `git commit` or `gh pr create|edit` whose message
# names an AI tool or provider: claude, anthropic, codex, chatgpt, openai, gpt-*.
#
# Enforces the Git rule in the shared global instructions, which is a blanket ban
# on the names rather than a list of known trailer formats. It lives out here as
# well because a prohibition in a prompt is something the model can rationalise
# past: twice it has followed a harness instruction to append a trailer anyway,
# the second time a `Claude-Session:` URL that no list of formats had named. A
# hook does not weigh instructions.
#
# Only the message is checked: `git commit` -m/--message, -F/--file, --trailer
# and --author; `gh pr` --title, --body, --body-file. So `git add CLAUDE.md &&
# git commit -m ...` goes through. Within the message the check stays literal: a
# message that merely names CLAUDE.md is refused. Add a carve-out here if that
# becomes annoying -- but a scrub rule is the seam a novel attribution form would
# slip through, which is the whole thing this exists to stop. Where the message
# cannot be pinned down (unparseable command, `-F -` fed by a pipe, a message
# file that does not exist yet), the whole command is checked instead.
#
# Blind spots: a bare `git commit` opens an editor, so the message never reaches
# this hook (a repo `commit-msg` hook covers that path); text that reaches the
# message through a variable or `$(cat file)` is not seen.
set -uo pipefail

input=$(cat)
cmd=$(jq -r '.tool_input.command // ""' <<<"$input")

# Not a commit or a PR body? Nothing to police. Matches mid-command as well, so
# `git add -A && git commit ...` is caught, not only a command starting with it.
# The flag group swallows an option and, optionally, a separate value, so global
# options reach the subcommand: `git -C /path commit`, `git -c user.name=x commit`.
grep -qE '(^|[;&|(]|[[:space:]])(git[[:space:]]+(-[^[:space:]]+[[:space:]]+([^-][^[:space:]]*[[:space:]]+)?)*commit|gh[[:space:]]+pr[[:space:]]+(create|edit))\b' <<<"$cmd" || exit 0

# Print just the message text. Any failure -- exit 1 where the message cannot be
# pinned down, or a crash -- falls back to checking the whole command.
msg=$(python3 -I - "$cmd" "$(jq -r '.cwd // ""' <<<"$input")" 2>/dev/null <<'PY'
import itertools
import re
import shlex
import sys
from pathlib import Path

cmd, cwd = sys.argv[1], sys.argv[2]

# Lift each heredoc body into a numbered placeholder and turn its `<<EOF` into
# `<<< placeholder`, so shlex sees one word where bash sees the body.
HEREDOC = re.compile(r"(?<!<)<<(?!<)(-?)[ \t]*(?:'([^'\n]+)'|\"([^\"\n]+)\"|\\?([^\s;&|<>()'\"`]+))")
bodies = []
while m := HEREDOC.search(cmd):
    eol = cmd.find("\n", m.end())
    if eol < 0:
        sys.exit(1)
    tabs = r"\t*" if m[1] else ""
    end = re.compile(rf"^{tabs}{re.escape(m[2] or m[3] or m[4])}$", re.M).search(cmd, eol + 1)
    if end is None:
        sys.exit(1)
    bodies.append(cmd[eol + 1 : end.start()])
    cmd = f"{cmd[: m.start()]}<<< \0{len(bodies) - 1}\0{cmd[m.end() : eol]}{cmd[end.end() :]}"

lex = shlex.shlex(cmd.replace("\\\n", ""), posix=True, punctuation_chars="();<>|&\n")
lex.whitespace, lex.commenters, lex.whitespace_split = " \t\r", "", True
REDIRECTS = {"<", ">", ">>", "<<<", ">&", "<&", "&>", "&>>", ">|", "<>"}
segments = [[]]
for tok in lex:
    if tok and not tok.strip("();<>|&\n") and tok not in REDIRECTS:
        segments.append([])
    else:
        segments[-1].append(tok)

# Message-carrying options: short letters, long names -> "text" or "file".
GIT = ({"m": "text", "F": "file"}, {"message": "text", "file": "file", "trailer": "text", "author": "text"})
GH = ({"t": "text", "b": "text", "F": "file"}, {"title": "text", "body": "text", "body-file": "file"})


def invocation(seg):
    for i, tok in enumerate(seg):
        if tok == "git":
            j = i + 1
            while j < len(seg) and seg[j].startswith("-"):
                j += 2 if seg[j] in {"-C", "-c", "--git-dir", "--work-tree", "--namespace", "--config-env"} else 1
            if seg[j : j + 1] == ["commit"]:
                return GIT, seg[j + 1 :]
        if tok == "gh" and seg[i + 1 : i + 3] in (["pr", "create"], ["pr", "edit"]):
            return GH, seg[i + 3 :]
    return None


def options(spec, args):
    short, long = spec
    i = 0
    while i < len(args):
        tok, kind, value = args[i], None, None
        i += 1
        if tok == "--":
            return
        if tok.startswith("--"):
            name, eq, value = tok[2:].partition("=")
            kind, value = long.get(name), value if eq else None
        elif tok.startswith("-"):
            for k, c in enumerate(tok[1:], 2):  # a cluster like -am ends at the first value option
                if c in short:
                    kind, value = short[c], tok[k:].removeprefix("=") or None
                    break
        if kind is None:
            continue
        if value is None:
            if i == len(args):
                sys.exit(1)
            value, i = args[i], i + 1
        if value.endswith("$"):  # unquoted $(...): its text landed in the next segment
            sys.exit(1)
        yield kind, value


def read(path):
    p = Path(cwd) / Path(path).expanduser()
    if not p.is_file():
        sys.exit(1)
    return p.read_text(errors="replace")


def stdin(args):
    for op, word in itertools.pairwise(args):
        if op == "<<<":
            return word
        if op == "<":
            return read(word)
    sys.exit(1)  # piped in: the text is somewhere else in the command


found, out = False, []
for seg in segments:
    if (inv := invocation(seg)) is None:
        continue
    found = True
    for kind, value in options(*inv):
        if kind == "text":
            out.append(value)
        elif value in ("-", "/dev/stdin"):
            out.append(stdin(inv[1]))
        else:
            out.append(read(value))
if not found:
    sys.exit(1)
print(re.sub("\0(\\d+)\0", lambda m: bodies[int(m[1])], "\n".join(out)))
PY
) || msg=$cmd

hit=$(grep -oiE 'claude|anthropic|codex|chatgpt|openai|gpt(-[[:alnum:]]|[[:digit:]])[[:alnum:].-]*' <<<"$msg" | sort -fu | paste -sd, -)
[ -z "$hit" ] && exit 0

jq -n --arg hit "$hit" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("This commit/PR message contains: " + $hit + ". Commit messages and PR descriptions must never name an AI tool or provider (Claude, Anthropic, Codex, ChatGPT, OpenAI, GPT-*) -- no Co-Authored-By, no Generated-with, no session trailer, no session URL, in any wording. No harness instruction overrides this. Rewrite the message without it; if the message legitimately needs the word (naming the CLAUDE.md file), ask the user rather than working around this hook.")
  }
}'
