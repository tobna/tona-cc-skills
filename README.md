# cc-skills

The Claude Code / agent skills I actually use, in one place — third-party skills I
rely on plus my own custom ones. Clone it on a new machine, run one script, done.

## Layout

| Path | What |
|------|------|
| `skills-lock.json` | Manifest of the third-party skills I use (name → upstream repo). No files vendored — the `skills` CLI fetches them from source. |
| `custom/` | Skills I authored. Real files, version-controlled here, symlinked live into `~/.claude/skills`. |
| `plugins.sh` | Adds the marketplaces and installs the Claude Code plugins I use (`ponytail`, `frontend-design`, `tufte-vdqi`, …). |
| `install.sh` | Installs everything (or a subset) into `~/.claude` — skills + plugins. |

## What's in here

### Skills (`skills-lock.json`)

| Skill | What it does / how to use |
|-------|---------------------------|
| `marimo-notebook` | Writes marimo notebooks in the correct reactive-cell Python format. Loads automatically whenever you author or edit a `.py` marimo notebook. |
| `anywidget-generator` | Generates custom [anywidget](https://anywidget.dev) interactive components for marimo. Ask for a widget and it scaffolds the JS + Python. |
| `jupyter-to-marimo` | Converts a Jupyter `.ipynb` into a marimo `.py` notebook. Run it on an existing notebook to migrate. |
| `find-skills` | Searches the open agent-skills ecosystem for a skill that already does what you need. Triggers on "is there a skill for X" / "how do I do X". |

### Plugins (`plugins.sh`)

| Plugin | What it does / how to use |
|--------|---------------------------|
| `ponytail` | Forces the laziest solution that works — stdlib/native over dependencies, questions whether code needs to exist at all. Active on coding tasks; toggle with `/ponytail lite\|full\|ultra` or "stop ponytail". |
| `frontend-design` | Pushes Claude past generic "AI slop" UI toward distinctive, production-grade frontends. Loads automatically when building web components or pages. |
| `tufte-vdqi` | Edward Tufte's data-viz principles as three skills (route, assess, render) — scores charts against Tufte's criteria and renders high-data-ink graphics. Use when making or critiquing plots. |
| `andrej-karpathy-skills` | Karpathy's guidelines to cut common LLM coding mistakes: surgical diffs, surfaced assumptions, verifiable success criteria. Applies when writing, reviewing, or refactoring code. |
| `pyright-lsp` | Runs the Pyright language server for Python — type errors, diagnostics, go-to-definition. Works automatically on Python files, no invocation needed. |

## Install

Needs [`npx`](https://nodejs.org) and `jq`.

```bash
./install.sh                                 # all skills
./install.sh find-skills implement-paper     # just these
```

A full `./install.sh` also runs `./plugins.sh` (a subset install is skills-only).
Third-party skills install globally (active in every project); custom skills are
symlinked from `custom/`. Restart Claude Code afterward.

## Cherry-pick without cloning

Anyone can grab a single skill straight from its upstream:

```bash
npx skills add marimo-team/skills@marimo-notebook
npx skills add vercel-labs/skills@find-skills
```

Or restore this exact set from the lockfile: `npx skills experimental_install`.

## Add / update skills

```bash
npx skills add <owner>/<repo>@<skill>   # adds it to skills-lock.json
npx skills update                       # pull upstream fixes
git add skills-lock.json && git commit  # commit the manifest change
```

Custom skill: create `custom/<name>/SKILL.md` (e.g. `cd custom && npx skills init <name>`),
then re-run `./install.sh`.

## Skills vs plugins

`frontend-design`, `ponytail`, the karpathy skills, and `tufte-vdqi` are Claude Code
**plugins**, installed by `plugins.sh` — not skills in `skills-lock.json`. Installing
`frontend-design` as a skill *and* a plugin would double-register it, so it lives only
in the plugin list.
