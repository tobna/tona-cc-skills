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

## AI-shaped prose

Reviewers increasingly recognize — and quietly discount — writing that reads as
LLM-generated. No single item below is forbidden; each is fine once in a while. **It's the
frequency and clustering that reads as AI, not any one instance.** The fix is almost always
"say it plainly."

- **Don't dodge "is" and "has."** AI reaches for *serves as, stands as, represents, functions
  as, acts as* instead of *is*, and *boasts, features, offers* instead of *has*. Write
  "Attention **is** the bottleneck," not "Attention **serves as** the bottleneck."
- **Cut the participial significance-tail** — the vague `-ing` clause bolted onto a sentence to
  inflate importance: "…, **further underscoring its scalability**", "…, **highlighting the
  importance of** alignment", "…, **contributing to** the broader field." Delete it, or replace
  it with a concrete consequence.
- **No false authority.** *Observers note, experts argue, studies have shown, it is widely
  regarded, researchers treat X as* — vague attributions implying a consensus with nothing
  behind them. In a paper, attribute to a specific citation or cut the claim.
- **Don't inflate significance.** *pivotal moment, marks a turning point, plays a crucial role,
  enduring legacy, rich landscape / tapestry, a testament to* — mundane results dressed as
  milestones. State what the result is; let the reader weigh it.
- **One name per concept** (also above) — synonym churn (drifting model → network →
  architecture → framework for the same thing) is a repetition-penalty artifact, not style.
  Repeat the term; consistency reads as rigor.
- **Skip the template "Challenges and Future Directions"** — "Despite its promise, X faces
  several challenges…" plus generic speculation. Write specific limitations tied to your actual
  results, or write nothing.
- **Vary structure.** Every paragraph as topic-sentence → three supports → restating summary
  reads as a filled-in template. Let the content set the shape.

The LaTeX/formatting counterparts — stray `\textbf`, equal-sized bullet stacks, em-dash spam,
colon lead-ins, "not X but Y," and the buzzword list — live in the `latex-rules` skill.

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
- [ ] No AI-shaped prose: plain "is/has", no significance-tails, no false authority, no template future-work.
- [ ] Figures use vector graphics and self-contained captions.
- [ ] Citations verified; error bars / statistics reported; compute and code/data availability stated.

For LaTeX mechanics (packages, cross-refs, tables, notation macros), use the
`latex-rules` skill.
