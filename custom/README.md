# Custom skills

Skills I author, version-controlled here. Each is a folder with a `SKILL.md`:

```
custom/my-skill/SKILL.md
```

`install.sh` symlinks every `custom/*` into `~/.claude/skills/`, so edits here are
live immediately. Bootstrap a new one with `npx skills init my-skill` inside this dir.
