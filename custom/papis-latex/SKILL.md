---
name: papis-latex
description: "Opinionated workflow for driving a LaTeX project's bibliography — use papis for generating the .bib with export + filter-cited, the Makefile targets, and the traps in papis bibtex (doctor, iscited, filter-cited). Use when the task touches a .bib, references, or citations: regenerating or adding entries, \\cite keys that don't resolve, entries missing or wrong, or any temptation to hand-edit a .bib."
---

# papis + LaTeX

Check `papis --version` first — without papis none of this applies, and **don't** install it to make it apply.

## Core idea

The library is the source of truth; the `.bib` is a generated artifact. Wrong author or
title? `papis edit`, then regenerate — wanting to edit the generated file is the signal to
edit the library instead. Commit the `.bib` anyway, so the document builds without papis
(co-authors, arXiv, CI). Presentational tweaks to it (trimming entries to fit a page limit)
are fine once the bibliography is final; they die on the next `make bib`.

## The pipeline

```sh
papis export -a -b -f bibtex -o <bib>
papis bibtex --no-auto-read read <bib> filter-cited -f <tex> unique save -f <bib>
```

**The dump is unfiltered on purpose.** `papis export` has no `.tex` awareness, and
`filter-cited`/`iscited` need an already-read `.bib`. The
alternative is handing `export` a query — which means _you_ picked the entries, and the
query rots the moment a citation falls outside it (so a `project:my-paper` tag loses too).
`--no-auto-read` stops papis loading a `default-read-bibfile` behind your back.

**`bibtex-ignore-keys` strips keys on export** — ignore `url` and no style can print one,
while `doctor -k url` reports it missing forever.

## Refs

**`\cite{}` keys must equal the library's `ref`,** which each entry stores in its
`info.yaml` — read them and match:

```sh
papis export -a -f bibtex | grep -oP '^@\w+\{\K[^,]+' | head
```

### Papis ref format and keys

Papis ref formats and ref keys are **global** properties and should be left alone if possible.
If you really think a ref key should change, you **have to** ask the user first, since it may (will!) affect other projects.
`ref-format` only names _new_ entries at `papis add` time; changing it renames nothing, so you probably should not!

**Add a paper:** `papis add --from arxiv <id> --batch` (also `doi`, `isbn`, `pmid`).

## Migrating to papis

Adopting papis for an existing document usually means renaming `\cite{}` calls in the `.tex` — the main migration cost.

Check the existing papis (default) library for the citation entries you need.
You may match via the ref key, but make sure it's really the same paper!
Otherwise, search for the title/author(s) in the papis library (for example via `papis list "<title words> author:<author>"`) and migrate to papis' ref key.
You can extract the citation entries you need to find from a possible `.bbl` file in the project tree.

If the project has no `Makefile` yet, add one using the template `Makefile` of this skill.
If it has a `Makefile`, adjust it while keeping the original intent.
You should probably add a `bib` build step to auto-update the library.

## Traps

| Trap                             | Reality                                                                                                                                                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `filter-cited -f a.tex -f b.tex` | **ORs** the files and emits duplicates — always follow with `unique`                                                                                                                                                 |
| `iscited -f a.tex -f b.tex`      | **ANDs** them: cited only if in _every_ file. Opposite of `filter-cited`, same flag. Pass the main file only — one citation-free `packages.tex` marks everything uncited                                             |
| ref matching                     | `re.search(ref, text)` — unanchored **regex**, not substring. Citing `Nauen2025a` also keeps `Nauen2025` (harmless)                                                                                                  |
| a hand-set `ref:`                | Skips the slugify that cleans generated refs (`[a-zA-Z0-9._:]` only), so it hits that regex verbatim: `Attention(2017)` matches `\cite{Attention2017}`, `Foo2017*` matches `Foo201`. Keep hand-set refs alphanumeric |
| `papis bibtex doctor`            | **Not** `papis doctor`. Ignores `doctor-default-checks`. `-k` defaults to `doi, url, year, title, author` — demands a DOI of every preprint. Always pass explicit `-k`                                               |
| `update-from-doc`                | Renamed to `update` in 0.15. `-f` pulls library→bib, `-t` pushes bib→library. On an orphan: warns, leaves it untouched                                                                                               |
| bibtex output                    | No dry-run — writes `.bbl`/`.blg` next to the `.aux`. **Any "check" that runs bibtex is not read-only**                                                                                                              |
| `latexmk`                        | Already drives latex/bibtex to a fixpoint. Never hardcode "2x latex → bib → 2x latex"                                                                                                                                |

## Makefile

**A ready-to-use [`Makefile`](Makefile) ships with this skill** — copy it in and edit
`TEX`/`BIB` at the top. Targets: `tex` (default, latexmk),
`bib` (regenerate from the library), `bib-check`, `clean`.

**papis does not run on a build** — only `make bib`, because regenerating is a **decision**, not a
side effect. **`bib-check` changes nothing**: it greps the last build's `.blg`.

Cold check: `make clean && rm -f main.bib && make bib && make full` → only cited entries in
`main.bib`, no `Citation.*undefined` in `main.log`.

## Config — only if explicitly asked for

A project-local `.papis.config`, merged over the global one, found relative to the **cwd**
(not the project root). For `[bibtex]` defaults belonging to this document:

```ini
[bibtex]
default-read-bibfile = main.bib
default-save-bibfile = main.bib
auto-read = True
```

`ref-format` is **global-only** — it applies to the library at add time, so scoping it per
project would give a paper a different ref depending on where it was added from.
Thus, **don't**.
