# Custom skills

Skills I author. `install.sh` symlinks each `custom/*` into `~/.claude/skills/` when `claude` is on `PATH`, and `~/.agents/skills/` when `codex` is on `PATH`, so edits go live immediately.

- [`paper-writing`](paper-writing/SKILL.md) — paper-writing guidance: framing, clarity, figures, citation integrity, rebuttals.
- [`latex-rules`](latex-rules/SKILL.md) — LaTeX conventions: packages, typography, tables, cleveref refs, source hygiene.
- [`papis-latex`](papis-latex/SKILL.md) — papis-driven bibliographies: the export/filter-cited pipeline, Makefile, `papis bibtex` traps.
- [`slidewriting`](slidewriting/SKILL.md) — Slidewriting method for talk decks: storyboard, action titles, framing, real slides, gated per step.
- [`python-rules`](python-rules/SKILL.md) — Python conventions: uv/ruff/pyright, modern syntax, loguru, portable tests.

Install into Claude Code — paste into the prompt:

```
Install the custom skills from github.com/tobna/tona-cc-skills (the custom/ folder) into ~/.claude/skills/.
```
