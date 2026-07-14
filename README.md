# tona-cc-skills

My Claude Code / agent skills — opinionated guides for academic paper writing and clean LaTeX.
The repo also bundles the third-party skills and plugins I rely on, so a single install sets
everything up.

**Install by asking Claude** — no clone needed. Paste into Claude Code:

```text
Install the custom skills from github.com/tobna/tona-cc-skills (the custom/ folder) into ~/.claude/skills/.
```

Only want some? Tell Claude which (e.g. "only `latex-rules`"). Re-run to update. Restart Claude
Code after installing. For the full set — third-party skills and plugins too — see [Install](#install).

## My skills (`custom/`)

| Skill           | What it does                                                                                                                        |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `paper-writing` | Opinionated paper-writing guidance — framing, abstract/intro, clarity, figures, rebuttals. Loads when drafting or revising a paper. |
| `latex-rules`   | Opinionated LaTeX conventions — packages, typography, math macros, booktabs/siunitx tables, cleveref refs. Loads on `.tex` files.   |

Like all skills, these **activate automatically** — you don't call them; Claude pulls one in
when you're doing the thing it covers.

## Also bundled

Third-party skills and Claude Code plugins I rely on. (Skills auto-load; a few tools ship as
**plugins** instead — same idea, different packaging.)

### Third-party skills (`skills-lock.json`)

| Skill                 | What it does                                                                                  |
| --------------------- | --------------------------------------------------------------------------------------------- |
| `marimo-notebook`     | Authoring marimo notebooks in the reactive-cell format. Auto-loads on `.py` marimo files.     |
| `anywidget-generator` | Scaffolds [anywidget](https://anywidget.dev) interactive components (JS + Python) for marimo. |
| `jupyter-to-marimo`   | Converts a Jupyter `.ipynb` into a marimo `.py` notebook.                                     |
| `find-skills`         | Finds an existing skill for a task. Triggers on "is there a skill for X".                     |

### Plugins (`plugins.sh`)

| Plugin                   | What it does                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------- |
| `ponytail`               | Forces the laziest solution that works. Toggle `/ponytail lite\|full\|ultra`.         |
| `frontend-design`        | Pushes past generic "AI slop" UI toward distinctive frontends. Loads on web UI work.  |
| `tufte-vdqi`             | Tufte's data-viz principles (route / assess / render) for making or critiquing plots. |
| `andrej-karpathy-skills` | Karpathy's guidelines to cut common LLM coding mistakes.                              |
| `pyright-lsp`            | Pyright language server for Python — type errors, diagnostics. Auto on `.py`.         |

## Install

**Custom skills, no clone** — ask Claude (the prompt up top), or in one line:
`Install the custom skills from github.com/tobna/tona-cc-skills into ~/.claude/skills/.`

**A single third-party skill**, straight from upstream:

```bash
npx skills add marimo-team/skills@marimo-notebook
```

**Full setup via script** — custom skills, third-party skills, and plugins at once (needs
`npx` + `jq`):

```bash
git clone https://github.com/tobna/tona-cc-skills && cd tona-cc-skills && ./install.sh
./install.sh find-skills paper-writing    # or a named subset (skills-only, no plugins)
```

Third-party skills install globally (active in every project); custom skills are symlinked
from `custom/`.

## Maintaining this repo

Track a third-party skill, pull upstream fixes, or restore the exact pinned set:

```bash
npx skills add <owner>/<repo>@<skill>   # adds it to skills-lock.json
npx skills update                       # pull upstream fixes
npx skills experimental_install         # restore the exact locked set
git add skills-lock.json && git commit
```

New custom skill: `cd custom && npx skills init <name>`, write its `SKILL.md`, re-run
`./install.sh`. A tool listed under **Plugins** lives only in `plugins.sh`, not
`skills-lock.json` — installing it as both would double-register it.

### Layout

| Path               | What                                                                         |
| ------------------ | ---------------------------------------------------------------------------- |
| `skills-lock.json` | Manifest of third-party skills (name → upstream repo). No files vendored.    |
| `custom/`          | Skills I authored. Real files here, symlinked live into `~/.claude/skills`.  |
| `plugins.sh`       | Adds the marketplaces and installs the Claude Code plugins.                  |
| `install.sh`       | Installs everything (or a named subset) into `~/.claude` — skills + plugins. |
