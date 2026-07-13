# cc-skills

The Claude Code / agent skills I actually use, in one place — third-party skills I
rely on plus my own custom ones. Clone it on a new machine, run one script, done.

## Layout

| Path | What |
|------|------|
| `skills-lock.json` | Manifest of the third-party skills I use (name → upstream repo). No files vendored — the `skills` CLI fetches them from source. |
| `custom/` | Skills I authored. Real files, version-controlled here, symlinked live into `~/.claude/skills`. |
| `install.sh` | Installs everything (or a subset) into `~/.claude`. |

## Install

Needs [`npx`](https://nodejs.org) and `jq`.

```bash
./install.sh                                 # all skills
./install.sh find-skills implement-paper     # just these
```

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

## Not here

`frontend-design` is used as a Claude Code **plugin** (`frontend-design@claude-plugins-official`),
not a skill — installing it here too would double-register it. Same for `ponytail` and the
karpathy skills: those live in the plugin/marketplace config, not this repo.
