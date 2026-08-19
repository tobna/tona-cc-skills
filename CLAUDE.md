# CLAUDE.md

My Claude Code / agent skills collection. Three sources, three install paths — keep all three
in sync with `README.md` whenever a skill is added, removed, or renamed.

## Skills

### Custom (`custom/*`, real files, symlinked into `~/.claude/skills`)

| Skill          | What it does                                                            |
| -------------- | ---------------------------------------------------------------------- |
| `paper-writing`| Academic paper writing/revising — framing, abstract/intro, figures, rebuttals. |
| `latex-rules`  | LaTeX conventions — packages, typography, math macros, booktabs/siunitx, cleveref. |
| `python-rules` | Python conventions — uv/ruff/pyright, modern syntax, loguru, tests.    |
| `papis-latex`  | papis-driven `.bib` generation for LaTeX projects — export + filter-cited, Makefile, `papis bibtex` traps. |

### Third-party (`skills-lock.json`, installed globally via `npx skills`)

| Skill                 | What it does                                                   |
| --------------------- | ------------------------------------------------------------- |
| `marimo-notebook`     | Authoring marimo notebooks in reactive-cell format.           |
| `anywidget-generator` | Scaffolds anywidget interactive components for marimo.        |
| `jupyter-to-marimo`   | Converts a Jupyter `.ipynb` into a marimo `.py` notebook.     |
| `find-skills`         | Finds an existing skill for a task.                           |
| `analyze-results`     | ML experiment results — stats, comparison tables, insights.   |

### Plugins (`plugins.sh`, `claude plugin install`)

| Plugin                   | What it does                                              |
| ------------------------ | -------------------------------------------------------- |
| `ponytail`               | Forces the laziest solution that works.                  |
| `frontend-design`        | Pushes past generic UI toward distinctive frontends.     |
| `tufte-vdqi`             | Tufte data-viz principles for making/critiquing plots.   |
| `andrej-karpathy-skills` | Karpathy's guidelines to cut common LLM coding mistakes. |
| `humanizer`              | Strips AI-sounding tells from prose so writing reads as human. |
| `pyright-lsp`            | Pyright language server for Python.                      |

## Layout

| Path               | What                                                                |
| ------------------ | ------------------------------------------------------------------ |
| `custom/`          | Skills I authored. Real files, symlinked live into `~/.claude/skills`. |
| `skills-lock.json` | Manifest of third-party skills (name → upstream repo). No files vendored. |
| `plugins.sh`       | Adds marketplaces and installs the plugins. Not in `skills-lock.json`. |
| `install.sh`       | Installs everything (or a named subset) into `~/.claude`.          |

A plugin lives only in `plugins.sh`, never also in `skills-lock.json` — listing it in both
double-registers it.
