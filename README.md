# tona-cc-skills

My Claude Code / Codex skills — opinionated guides for academic paper writing and clean LaTeX.
The repo also bundles the third-party skills and plugins I rely on, so a single install sets
everything up.

**Install by asking Claude** — no clone needed. Paste into Claude Code:

```text
Install the custom skills from github.com/tobna/tona-cc-skills (the custom/ folder) into ~/.claude/skills/.
```

Only want some? Tell Claude which (e.g. "only `latex-rules`"). Re-run to update. Restart Claude
Code after installing. For the full set — third-party skills and plugins too — see [Install](#install).

## My skills (`custom/`)

| Skill                                            | What it does                                                                                     |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [`paper-writing`](custom/paper-writing/SKILL.md) | Writing and revising papers — framing, abstract/intro, clarity, figures, rebuttals.              |
| [`latex-rules`](custom/latex-rules/SKILL.md)     | LaTeX conventions — packages, typography, math macros, booktabs/siunitx tables, cleveref.        |
| [`python-rules`](custom/python-rules/SKILL.md)   | Python conventions — uv/ruff/pyright, modern syntax, loguru, tests that run anywhere.            |
| [`papis-latex`](custom/papis-latex/SKILL.md)     | papis-driven `.bib` for LaTeX projects — export + filter-cited, Makefile, `papis bibtex` traps.  |
| [`slidewriting`](custom/slidewriting/SKILL.md)   | Talk decks via the Slidewriting method — storyboard, action titles, framing, slides; gated per step. |

Like all skills, these **activate automatically** — you don't call them; Claude pulls one in
when you're doing the thing it covers.

## Also bundled

### Third-party skills (`skills-lock.json`)

| Skill                 | What it does                                                                |
| --------------------- | --------------------------------------------------------------------------- |
| `marimo-notebook`     | Authoring marimo notebooks in the reactive-cell format.                     |
| `anywidget-generator` | Scaffolds [anywidget](https://anywidget.dev) components for marimo.         |
| `jupyter-to-marimo`   | Converts a Jupyter `.ipynb` into a marimo `.py` notebook.                   |
| `find-skills`         | Finds an existing skill for a task.                                         |
| `analyze-results`     | ML experiment results — stats, comparison tables, insights.                 |
| `openscad`            | Parametric 3D CAD with OpenSCAD — design, STL reconstruction, print export. |

### Plugins (`plugins.sh`)

| Plugin                   | What it does                                             |
| ------------------------ | -------------------------------------------------------- |
| `ponytail`               | Forces the laziest solution that works.                  |
| `frontend-design`        | Pushes past generic UI toward distinctive frontends.     |
| `tufte-vdqi`             | Tufte's data-viz principles for making or critiquing plots. |
| `andrej-karpathy-skills` | Karpathy's guidelines to cut common LLM coding mistakes. |
| `pyright-lsp`            | Pyright language server for Python.                      |
| `humanizer`              | Strips AI-sounding tells from prose.                     |

### Hooks (`hooks/`)

`no-ai-attribution.sh` refuses a `git commit` or `gh pr create`/`edit` whose message contains
"claude", "anthropic", "codex", "chatgpt", "openai", or "gpt-…", in any wording. Only the
message is checked: committing a `CLAUDE.md` file is fine, a message naming it is not.

### Statusline

I use [ClaudeCodeStatusLine](https://github.com/daniel3303/ClaudeCodeStatusLine). Ask Claude:

```text
Clone https://github.com/daniel3303/ClaudeCodeStatusLine to ~/.claude/statusline/ (or %USERPROFILE%\.claude\statusline\ on Windows) and configure it as my status bar by following its INSTALL.md.
```

## Install

**Custom skills only** — [ask Claude](#tona-cc-skills), no clone needed.

**Full setup via script** — custom skills, third-party skills, hooks, plugins, and the shared
global instructions at once, for Claude Code and/or Codex (needs `npx` + `jq`):

```bash
git clone https://github.com/tobna/tona-cc-skills && cd tona-cc-skills && ./install.sh
./install.sh find-skills paper-writing    # or a named subset (skills only)
```

The shared instructions ([`global/agent-instructions.md`](global/agent-instructions.md)) replace
`~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`; existing files are backed up first. Restart the
CLI afterwards.

## Maintaining

```bash
npx skills add <owner>/<repo>@<skill>   # track a third-party skill in skills-lock.json
npx skills update                       # pull upstream fixes
npx skills experimental_install         # restore the exact locked set
```

New custom skill: `cd custom && npx skills init <name>`, write its `SKILL.md`, re-run
`./install.sh`; edits to existing skills show up through the links. A plugin lives only in
`plugins.sh`, never also in `skills-lock.json`, or it registers twice. After touching a hook,
run `tests/no-ai-attribution.sh`.
