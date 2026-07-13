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
\usepackage microtype          % better justification; load LAST-ish, after fonts
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

Never hand-type "Figure~\ref{...}". Use `\cref` / `\Cref` so the word and number stay
linked and consistent:

```latex
\cref{fig:arch}        % → "fig. 3"      (mid-sentence)
\Cref{sec:method}      % → "Section 2"   (sentence start)
\cref{eq:loss,eq:reg}  % → "eqs. (4) and (5)"
```

Label with a type prefix, always right after `\caption`/`\section`/`\label`-target:
`fig:`, `tab:`, `eq:`, `sec:`, `alg:`, `thm:`, `app:`. Use `\eqref` only if not using
cleveref. A `\label` for a float goes *after* its `\caption`, or the number is wrong.

## Typography

- **Dashes**: `-` hyphen (intra-word), `--` en-dash (ranges: `pages 5--10`), `---` em-dash (—no spaces around it).
- **Quotes**: `` `single' `` and ` ``double'' ` — never the straight `"`.
- **Ellipsis**: `\dots`, never `...`.
- **Non-breaking space `~`** before every reference and citation and inside number+unit when not using siunitx: `Figure~\ref{...}`, `\citep{...}` (prefer `~\cite`), `Section~\ref`, `5~kg`. Prevents a number stranded at a line start.
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
- Multi-line alignment with `align`; align within a single equation using `aligned`.
- Delimiters: `\left( … \right)` auto-sizes but can oversize — prefer manual `\bigl( \bigr)` / `\Bigl` when you know the height.
- Words inside math: `\text{...}` (needs amsmath), not `\mbox` or roman hacks.
- Reuse notation consistently; define macros for recurring symbols (see below).
- Reference equations with `\cref{eq:...}` / `\eqref`, never a raw "(3)".

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

## Removing AI-isms

LaTeX and prose that "smell" AI-generated get noticed and discounted by reviewers. None of
the tells below is outright banned — each is fine used **very sparingly**, roughly once per
one or two pages. It's the *frequency and clustering* that reads as AI, not any single
instance. So the bullets below mean "keep rare," not "never."

**Vocabulary tells** — cut the AI buzzwords: *leverage, utilize, delve, showcase, seamless,
comprehensive, pivotal, underscore, realm, testament, tapestry, meticulous*, and *robust* as
filler. Cut sentence-opening transition spam: *Furthermore, Moreover, Additionally, Notably,
Importantly, Overall, In conclusion, It is worth noting that.* (See the `paper-writing` skill
for the narrative-level version.)

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
- [ ] All refs via `\cref`/`\Cref`; every float `\label` after its `\caption`.
- [ ] `--` for ranges, `---` for em-dash, `` `` ''`` quotes, `\dots`, `~` before cites/refs.
- [ ] Tables use booktabs (no vrules/`\hline`); numbers aligned via `S` columns.
- [ ] Numbers/units via siunitx, or a thin space `\,` between every number and its unit; figures are vector; captions self-contained.
- [ ] One sentence per line; no `\\` paragraph breaks; no obsolete packages.
- [ ] Display math via `align*`/`equation`, never `\[\]`/`$$`/`eqnarray`; inline via `$…$`.
- [ ] No AI buzzword/transition spam; emphasis via `\emph` (bold only rarely, for key terms).
