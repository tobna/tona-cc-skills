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
npx skills add marimo-team/skills@implement-paper
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
