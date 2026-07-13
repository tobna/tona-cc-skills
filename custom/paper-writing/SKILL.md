---
name: paper-writing
description: Opinionated guidance for writing and revising academic/research papers — narrative framing, abstract and introduction structure, sentence-level clarity, figure design, and the mistakes reviewers punish. Use when drafting, revising, or reviewing a paper, abstract, introduction, related work, or rebuttal, or when prose feels generic, templated, or AI-shaped.
---

# Paper writing

A paper is not a log of experiments. It is **one technical claim, organized into a
story a reviewer is willing to believe.** Everything below serves that.

Distilled from the writing views of Neel Nanda, Andrej Karpathy, Sebastian Farquhar,
Zachary Lipton, and Gopen & Swan's *The Science of Scientific Writing*.

## Start here: the one-sentence test

Before drafting, write the contribution as **one sentence**:

- "We prove X converges under assumption Y."
- "We show method A improves B by 15% on benchmark C."
- "We identify failure mode D and propose mechanism E that removes it."

If you can't, the framing hasn't converged — the contribution is vague, the evidence
isn't yet coupled to the claim, or the paper doesn't know its story. **Fix this before
writing prose.** Every section then supports that one claim; none launches a second one.

## Where effort goes

Reviewers read **Title → Abstract → Introduction → Figure 1 → the rest**, and often
judge before reading the method carefully. So spend roughly equal effort on: the
**abstract**, the **introduction**, the **figures**, and everything else *combined*.
Never bury the contribution after Section 3.

## Abstract — five sentences

1. What you achieved (the specific contribution — sentence 1 or 2, not generic).
2. Why the problem is important *and* hard.
3. How you approached it.
4. What evidence supports the claim.
5. The one number / result / guarantee to remember.

Include ≥1 quantitative result. Must stand alone: no undefined acronyms, no reliance
on citations. **Delete any opening that fits every ML paper** ("Large language models
have achieved remarkable success…", "In recent years, deep learning…") — it carries no
information a reviewer can use.

## Introduction — 1 to 1.5 pages

Structure: **hook** (what problem, why now) → **challenge** (why it's hard, why prior
work is insufficient) → **approach** (what's different, the key insight) → **2–4
contribution bullets** → **results preview** (surface the strongest result early) →
optional roadmap. The method should start appearing by page 2–3.

Contribution bullets must be **falsifiable** — a reviewer should be able to agree or
disagree:

- Good: "We prove X converges in O(n log n) under Y." / "Architecture Z cuts memory 40%."
- Bad: "We study problem X." / "We perform extensive experiments." / "We make several contributions."

## Sentence-level clarity

Readers have structural expectations; violating them makes them decode instead of
understand. Seven habits:

1. **Keep subject and verb close** — don't wedge a clause between them.
2. **End on the important information** — "When using attention, accuracy improves 15%."
3. **Open with context** — "To address the alignment problem, we introduce…"
4. **Old before new** — start with the familiar, end on the new point.
5. **One unit, one job** — a paragraph does one thing; a two-logic sentence wants to be two.
6. **Actions live in verbs** — "we analyzed" not "we performed an analysis of."
7. **Set the stage** before an equation/theorem/result — say why it matters first.

Paragraph shape: **point first**, support in the middle, reinforce/transition at the
end. Never bury the key sentence in the middle.

## Word choice

- **Cut hedging** unless the uncertainty is real: *may, can, might, potentially*. Overhedging reads as self-doubt, not rigor.
- **Cut fillers**: *actually, very, really, quite, basically, essentially, Importantly, Notably, It is worth noting that.*
- **Replace vague with specific**: performance → *accuracy / F1 / latency*; improves → *increases by X%*; large → *1B parameters*; fast → *3× faster*.
- **One name per concept** — don't drift between model/network/architecture, or sample/instance/example.
- **Verbs signal contribution**: prefer *develop, propose, introduce, characterize* over *combine, modify, extend, expand* — wording shapes whether a reviewer reads it as real work.

## Mathematical writing

Goal: let the reader **follow**, not sound sophisticated. State assumptions *before* the
theorem; pair proofs with intuition (keep intuition in the main text, not only the
appendix); keep notation consistent; define every symbol at first use. Conventional
notation: scalars lowercase italic `$x$`; vectors lowercase bold `$\mathbf{x}$`;
matrices uppercase bold `$\mathbf{W}$`; sets calligraphic `$\mathcal{X}$`; named
functions roman `$\mathrm{softmax}$`.

## Figures

Figure 1 is read right after the abstract — it should explain the core idea, show the
strongest comparison, or give the simplest visual summary of the main claim. Rules:

- **Captions are self-contained** — state what is compared and what to notice; don't depend on the surrounding paragraph.
- **Vector graphics** (PDF/EPS), never raster plots.
- **No decorative title inside the figure** — put it in the caption.
- **Colorblind-safe**: avoid red-green, work in grayscale, use line styles/markers in addition to color.

## Common mistakes → fixes

| Mistake | Fix |
|---|---|
| Intro > 1.5 pages | Move background to Related Work |
| Method buried late | Front-load the contribution |
| No contribution bullets | Add 2–4 concrete, falsifiable claims |
| Experiments not tied to claims | State what each experiment tests |
| Generic abstract opening | Start from the actual contribution |
| Related Work as paper-by-paper list | Reorganize by method family / research question |
| AI-generated / unverified citations | Verify every reference against a real source |
| Inconsistent terminology | One name per concept |

## Pre-submission checklist

- [ ] Contribution stateable in one sentence; intro makes What / Why / So-What clear.
- [ ] Every major experiment supports a stated claim.
- [ ] Abstract follows the five-sentence formula with a quantitative result.
- [ ] Intro ≤ 1.5 pages; method appears by page 2–3; 2–4 contribution bullets.
- [ ] Limitations stated. Terminology consistent. No generic openings. Hedging trimmed.
- [ ] Figures use vector graphics and self-contained captions.
- [ ] Citations verified; error bars / statistics reported; compute and code/data availability stated.

For LaTeX mechanics (packages, cross-refs, tables, notation macros), use the
`latex-rules` skill.
