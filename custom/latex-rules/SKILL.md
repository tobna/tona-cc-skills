---
name: latex-rules
description: Opinionated LaTeX conventions for academic papers — required packages, typography (dashes, quotes, non-breaking spaces), math notation and macros, booktabs tables, siunitx numbers, figures, cleveref cross-references, source hygiene, and obsolete packages to never use. Use when writing, editing, or reviewing .tex files or when a document's LaTeX looks sloppy or dated.
---

# LaTeX rules

Opinionated, non-negotiable conventions for clean academic LaTeX. Rules first; the
reasoning is short because these are settled practice (l2tabu; the `booktabs`,
`siunitx`, `microtype`, `cleveref` manuals; long-standing tex.stackexchange consensus).

## Preamble — always load these

```latex
\usepackage[T1]{fontenc}       % proper 8-bit fonts, real hyphenation
\usepackage[utf8]{inputenc}    % (skip under LuaLaTeX/XeLaTeX — already UTF-8)
\usepackage[protrusion=true,expansion=true]{microtype}  % char protrusion + font expansion; load LAST-ish, after fonts
\usepackage{amsmath, amssymb}  % never eqnarray; amsmath instead
\usepackage{booktabs}          % professional tables
\usepackage{siunitx}           % numbers, units, aligned decimals
\usepackage graphicx
\usepackage{subcaption}        % NOT subfigure / subfig
\usepackage[hidelinks]{hyperref}   % load near-last
\usepackage{cleveref}          % load AFTER hyperref
```

Load order that matters: `hyperref` near the end, `cleveref` **after** `hyperref`,
`microtype` after font packages.

**microtype**: `protrusion` (hangs punctuation into the margin) and `expansion` (subtly
stretches glyphs to improve justification) are the two that matter — turn both on. Both work
under pdfLaTeX and LuaLaTeX; `expansion` is unsupported under XeLaTeX, so drop it there. It
silences most overfull-`\hbox` warnings for free and is the single cheapest quality win in the
preamble.

**A ready-to-use [`packages.tex`](packages.tex) ships with this skill** — the maintained
preamble plus the reusable macro set (number sets, operators, bold vectors/matrices,
colors, the `takeaway` box). Copy it into the project and `\input{packages}` (no `.tex`) in the
main document. Reusable notation goes in `packages.tex`; **one-off names used only in
this paper (method name, dataset shorthand) are defined in the main `.tex`, not here.**

**Keep `packages.tex` current:** when you improve the preamble while working on a paper —
a new reusable macro, a better package, a bug fix — and the change would help future
papers too, mirror it back into *this skill's* `packages.tex` (the single source of
truth) and commit, so the next paper starts from the improved version. Leave genuinely
paper-specific bits out of it.

## Cross-references — cleveref, always

Never hand-type "Figure~\ref{...}". Use cleveref so the word and number stay linked and
consistent — and **prefer `\Cref` (capitalized) everywhere**, even mid-sentence, over `\cref`.
Consistent "Figure 3" / "Equation (5)" reads cleaner than the lowercase "fig." form and stays
correct regardless of the `capitalize` option. Shipped preamble uses `[capitalize,noabbrev]`:

```latex
\Cref{fig:arch}        % → "Figure 3"
\Cref{sec:method}      % → "Section 2"
\Cref{eq:loss,eq:reg}  % → "Equations (4) and (5)"
```

Drop to lowercase `\cref` when a venue wants lowercase names mid-sentence, or **to save space
on a tight page limit** — combine it with dropping `noabbrev` (→ "Fig. 3", "Sec. 2", "Eq. (5)")
for the most compact form. Whichever you pick, stay consistent across the paper.

Label with a type prefix, always right after `\caption`/`\section`/`\label`-target:
`fig:`, `tab:`, `eq:`, `sec:`, `alg:`, `thm:`, `app:`. Use `\eqref` only if not using
cleveref. A `\label` for a float goes *after* its `\caption`, or the number is wrong.

## Typography

- **Dashes**: `-` hyphen (intra-word), `--` en-dash (ranges: `pages 5--10`), `---` em-dash (—no spaces around it).
- **Quotes**: `` `single' `` and ` ``double'' ` — never the straight `"`.
- **Ellipsis**: `\dots`, never `...`.
- **Non-breaking space `~`** before every citation and inside a hand-written number+unit when not using siunitx: `~\cite{...}`, `5~kg`. Prevents a number stranded at a line start. Cross-references need **no** manual `~` — always `\Cref{fig:...}`, never `Figure~\ref{...}`; cleveref supplies the word *and* the tie for you.
- **Citation placement — scope sets the position**:
  - a specific **term** → immediately after that term, bound with `~`: `the transformer~\cite{vaswani2017} scales well.`
  - an **assertion / clause** → right after it, wherever that clause ends in the sentence.
  - a **whole sentence** → at the end, *before* the period: `…and this holds across scales~\cite{kaplan2020}.`
  - a **whole paragraph** (occasional only) → *after* the period: `…broadly applicable.~\cite{kaplan2020}`
- **Emphasis**: `\emph{...}` by default (nests correctly); never `\textit` for emphasis, never the deprecated `{\it ...}` / `{\bf ...}`. `\textbf` bold emphasis is allowed but only **very rarely** — for a genuinely key term, not routine emphasis.
- **Run-in headings, not `\paragraph`**: to save vertical space, open the paragraph with a bold lead-in `\textbf{Heading.}` (text, then a period) rather than `\paragraph{Heading}`. `packages.tex` provides `\parahead{Heading}` for this.
- **Spacing after abbreviations**: `e.g.\ ` and `i.e.\ ` (backslash-space) so the period isn't treated as sentence-end; or use a macro.
- **Always a thin space `\,` between a number and its unit**: `5\,\mathrm{ms}`, `10\,\mathrm{kg}`, `3.3\,\mathrm{GHz}` — never `5ms` or `5 ms` (a full space is too wide and can break across lines). `siunitx`'s `\qty{5}{\milli\second}` does this for you; use `\,` when writing units by hand.

## Math

- **Display math**: `align*` (unnumbered) or `align`/`equation` (numbered) — never `\[ … \]`, `$$ … $$`, or `eqnarray`. **Inline math**: `$ … $`, not `\( … \)`.
- `\DeclareMathOperator{\argmax}{arg\,max}` for named operators — never `\text{argmax}` or bare `argmax` (wrong spacing/font).
- Multi-line alignment with `align` gives one number *per line*. For a **single equation broken across rows that should carry only one number**, use `split` (aligned on `&`) inside `equation` or `align` — the number sits centered on the whole block:

```latex
\begin{equation}
  \begin{split}
    \mathcal{L} &= \mathbb{E}[\ell(x, y)] \\
                &\quad + \lambda \lVert \theta \rVert^2 .
  \end{split}
\end{equation}
```

  Use `aligned` instead when the aligned block is a sub-part of a larger expression (it carries no number of its own).
- Delimiters: `\left( … \right)` auto-sizing is allowed and a fine default. Switch to manual `\bigl( \bigr)` / `\Bigl` only when auto oversizes (e.g. it hugs a subscript or fraction too loosely) and you know the height you want.
- Words inside math: `\text{...}` (needs amsmath), not `\mbox` or roman hacks.
- Reuse notation consistently; define macros for recurring symbols (see below).
- Reference equations with `\Cref{eq:...}` (→ "Equation (3)"), never a raw "(3)". Lowercase `\cref{eq:...}` (→ "eq. (3)") is the compact fallback to save space — same consistency rule as the other cross-refs. `\eqref{eq:...}` (→ bare "(3)") only when the sentence already names the equation — and it needs a manual tie, `loss~\eqref{eq:...}`, since (unlike `\cref`/`\Cref`) it supplies no word of its own.
- **Picky niceties** (nice to have, not blocking): `\coloneqq` for a definition `:=` and `\eqqcolon` for `=:` (both from `mathtools`) — the spacing around a bare `:=` is wrong; `\colon` not a bare `:` in a map `f\colon A \to B` (bare `:` is a relation, too much space); `\dots` not `...` (already required above).

## Tables — booktabs

No vertical rules. No `\hline`. Only `\toprule`, `\midrule`, `\bottomrule`. Align
numeric columns on the decimal with `siunitx`'s `S` column:

```latex
\begin{tabular}{l S[table-format=2.1] S[table-format=1.3]}
  \toprule
  Method & {Acc.\ (\%)} & {F1} \\
  \midrule
  Ours   & 92.4 & 0.851 \\
  \bottomrule
\end{tabular}
```

Header cells over `S` columns need `{braces}` to stay text. Never eyeball-align numbers.

## Numbers and units — siunitx

`\num{1.2e-3}`, `\qty{5}{\milli\second}`, `\SI`-style ranges `\qtyrange{5}{10}{\kg}`,
percentages `\qty{92.4}{\percent}`. One source of truth for formatting; consistent
thin-space grouping and minus signs everywhere.

By-hand units with a thin space — `5\,\mathrm{ms}`, `10\,\mathrm{kg}` — are also fine, but
**pick one approach and keep it consistent across the whole paper**: don't mix `\qty{5}{\ms}`
in one place with `5\,\mathrm{ms}` in another. siunitx is the safer default (uniform spacing,
minus signs, and ranges for free); hand-written `\,` is acceptable when you'd rather not pull
in the full machinery.

## Figures

- **Vector only**: PDF (or EPS). Never PNG/JPG for plots.
- `\centering` inside the float — never `\begin{center}…\end{center}` (adds stray vertical space).
- Subfigures via `subcaption`'s `subfigure` env, not the obsolete `subfigure`/`subfig` packages.
- `\includegraphics[width=\linewidth]{...}` — scale by `\linewidth`/`\columnwidth`, never hardcode `cm`.
- Placement `[t]` or `[tb]`; avoid `[h]`/`[H]` fights with the float algorithm.
- Self-contained captions (see the `paper-writing` skill).

## Source hygiene

- **One sentence per line** (semantic line breaks). Keeps git diffs and review comments
  sane; line breaks don't affect output. Never reflow a whole paragraph on a one-word edit.
  If a project *does* enforce a max line length, keep the max-one-sentence-per-line rule anyway:
  never start a second sentence on a line, and when a single long sentence must wrap, break at a
  clause boundary — right after `. ! ? ; : ,` — not mid-clause. Sentence-end still gets its own break.
- **Auto-format for indentation, never for reflow.** Use `latexindent` (or `tex-fmt`) to keep
  environment nesting and indentation consistent — but **keep line-wrapping off** so it never
  reflows prose, which would wreck one-sentence-per-line and explode diffs. `latexindent`
  leaves line breaks alone by default (don't enable `modifyLineBreaks`); for `tex-fmt` set
  `wrap = false`. Run it on save or in a pre-commit hook so formatting stays out of content diffs.
- **Blank line = paragraph break.** Never `\\` to end a paragraph (it makes a bad
  hanging line). `\\` is only for tabular/align/forced breaks.
- **Define repeated notation as macros** — never type the same construct inline twice.
  Reusable ones live in `packages.tex`; use `\newcommand`, never `\def` (no clash protection):
  - **Bold vectors/matrices**: `\newcommand{\bx}{\mathbf{x}}`, `\newcommand{\bW}{\mathbf{W}}` — write `\bx`, not `\mathbf{x}`, every time.
  - **Number sets**: `\newcommand{\R}{\mathbb{R}}`, `\newcommand{\E}{\mathbb{E}}`.
  - **Named operators**: `\DeclareMathOperator{\softmax}{softmax}`, or the `\newcommand{\cov}{\operatorname{cov}}` form used throughout `packages.tex` — never bare `softmax` (wrong font/spacing).
  - **One-off project names** (method name, this paper's dataset shorthand): define in the **main `.tex`**, not `packages.tex` — they don't belong in the reusable preamble.
- Don't fix spacing with `\vspace`/`\hspace` hacks or `~~~`; fix the cause.
- Comment out, don't delete, when unsure — but strip dead commented blocks before submission.
- **Keep the paper in git.** Track sources (`.tex`, `.bib`, figures, `packages.tex`); ignore the build cruft LaTeX regenerates (`.aux`, `.log`, `.out`, `.bbl`, `.synctex.gz`, `.fdb_latexmk`, …). Copy the bundled [`latex.gitignore`](latex.gitignore) into the project as `.gitignore`. Even a **local-only repo with no remote is far better than none** — one sentence per line plus git makes every change reviewable and revertible.

## Draft mode (opt-in — recommended for theses, optional for short papers)

One boolean toggles a bundle of author-facing scaffolding that never reaches the final PDF.
**This earns its keep on long documents (theses, tech reports) where you review with
co-authors and page-count is loose; for a short single paper it's usually overkill** — decide
by length. `packages.tex` ships the block, off by default. Enable it by adding **one line to
the main `.tex`, before `\input{packages}`**:

```latex
\newif\ifdraftmode \draftmodetrue   % ← comment out (or delete) this line for the final build
\input{packages}
```

When on, it switches on three aids at once; when off (the line commented), all of them vanish:

- **`\overfullrule=5pt`** — a black bar in the margin at every overfull line, so you *see*
  bad boxes instead of hunting the log.
- **`lineno` line numbers** — co-authors and reviewers can say "line 214". (Numbers prose;
  `align`/`equation` bodies aren't numbered without extra setup.)
- **`showkeys`** — prints each `\label`/`\ref` key in the margin: no more guessing what a
  float is called while cross-referencing.

The red **`\todo{...}`** boxes are *not* tied to this toggle — they work with or without draft
mode, exactly as before, so drop a `\todo` anywhere and strip them before submitting. (If you'd
rather a stray TODO fail the final build, redefine `\todo` to a `\PackageError`.)

Because this uses its own boolean (not `\documentclass[draft]`), figures still render and
`microtype` stays on. (If you ever *do* pass the class-level `draft` option, note it turns
`microtype` off — pass `final` to microtype to keep it.)

## Linting

A linting stack catches mechanical issues before a co-author or reviewer does. **Don't
*install* any of these unprompted** — but if one is **already installed** (check first, e.g.
`command -v chktex`), running it is fine, and you may **recommend** adopting one when the
document would clearly benefit (recurring dash/ref/spacing slips, a co-authored draft, prose
that reads AI-shaped).

- **`chktex`** — LaTeX-specific warnings: missing `~` before refs, wrong dash lengths, `\ldots`
  vs `\dots`, spacing slips. The closest fit to these rules; run it first.
- **`Vale`** — prose style/consistency against a configurable vocabulary — good for enforcing the
  AI-ism word list below and house terminology.
- **LTeX+** — grammar and spelling on a LanguageTool engine, but LaTeX-aware: the LSP
  extension (VS Code / Neovim) parses `.tex` directly, so there's no markup-stripping step and
  far fewer false positives on commands. The maintained successor to the original LTeX.

## Removing AI-isms

LaTeX and prose that "smell" AI-generated get noticed and discounted by reviewers. None of
the tells below is outright banned — each is fine used **very sparingly**, roughly once per
one or two pages. It's the *frequency and clustering* that reads as AI, not any single
instance. So the bullets below mean "keep rare," not "never."

**Vocabulary tells** — cut the AI buzzwords: *leverage, utilize, delve, showcase, seamless,
comprehensive, pivotal, underscore, realm, testament, tapestry, meticulous, intricate, nuanced,
crucial, foster, boast, landscape*, and *robust* as filler. Cut sentence-opening transition
spam: *Furthermore, Moreover, Additionally, Notably, Importantly, Overall, In conclusion, It is
worth noting that.* The **structural** prose tells — dodging "is/has" (*serves as*, *boasts*),
participial significance-tails, false authority (*experts argue*), significance inflation,
synonym churn, template future-work sections — live in the `paper-writing` skill.

**Formatting tells**

- Don't `\textbf` random phrases — bold is for rare, genuinely-key terms; routine emphasis is `\emph`, used sparingly.
- Don't turn prose that should be sentences into equal-sized bullet lists or a stack of identical `\paragraph`/`\parahead` blocks. Vary structure to the content.
- Don't end every section/paragraph with a restating summary, and don't over-signpost ("As mentioned above", "As we will see").
- Avoid the tidy tricolon ("fast, efficient, and scalable"), uniform paragraph lengths, and em-dash spam (at most one `---` per paragraph).
- Don't use the colon `:` as a dramatic lead-in ("The takeaway is clear:", "One key insight:", "Our approach: …") — rewrite as a plain sentence. Colons are for lists and genuine appositives, not emphasis.
- Kill the negation-parallelism cliché: "It's not X, it's Y", "not only … but …", "This isn't just about X — it's about Y". State the point directly instead of dressing it as a reversal.

## Never use (obsolete — l2tabu)

| Don't | Use instead |
|---|---|
| `eqnarray` | `align` (amsmath) |
| `\bf`, `\it`, `\rm`, `\tt` | `\textbf`, `\emph`, `\textrm`, `\texttt` |
| `subfigure`, `subfig` | `subcaption` |
| `epsfig`, `\psfig` | `graphicx` + `\includegraphics` |
| `a4wide`, `fullpage` | `geometry` |
| `times`, `pslatex` | `newtxtext`/`newtxmath` or `mathptmx` |
| `\centerline` | `\centering` |
| `$$ … $$`, `\[ … \]` | `align*` (unnumbered) / `equation` (numbered) |

## Quick review pass

- [ ] `microtype` on; `hyperref`+`cleveref` loaded in that order.
- [ ] All refs via `\Cref` (preferred) / `\cref`; every float `\label` after its `\caption`.
- [ ] `--` for ranges, `---` for em-dash, `` `` ''`` quotes, `\dots`, `~` before cites/refs.
- [ ] Tables use booktabs (no vrules/`\hline`); numbers aligned via `S` columns.
- [ ] Numbers/units via siunitx, or a thin space `\,` between every number and its unit; figures are vector; captions self-contained.
- [ ] One sentence per line; no `\\` paragraph breaks; no obsolete packages.
- [ ] Display math via `align*`/`equation`, never `\[\]`/`$$`/`eqnarray`; inline via `$…$`.
- [ ] No AI buzzword/transition spam; emphasis via `\emph` (bold only rarely, for key terms).
