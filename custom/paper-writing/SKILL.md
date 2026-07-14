---
name: paper-writing
description: Opinionated guidance for writing and revising academic/research papers — narrative framing, abstract and introduction structure, sentence-level clarity, figure design, citation integrity, and the mistakes reviewers punish. Use when drafting, revising, or reviewing a paper, abstract, introduction, related work, or rebuttal; when checking that citations/references are real and correctly used; or when prose feels generic, templated, or AI-shaped.
---

# Paper writing

A paper is not a log of experiments. It is **one technical claim, organized into a
story a reviewer is willing to believe.** Everything below serves that.

Distilled from the writing views of Neel Nanda, Andrej Karpathy, Sebastian Farquhar,
Zachary Lipton, Gopen & Swan's *The Science of Scientific Writing*, Mensh & Kording's
*Ten Simple Rules for Structuring Papers*, and Simon Peyton Jones's *How to Write a Great
Research Paper*.

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

## Structure: Context → Content → Conclusion

One shape repeats at every scale: **set context, deliver content, land a conclusion.** The
paper (intro → results → discussion), each section, each paragraph (topic sentence → support →
takeaway), and the abstract all follow it. When a passage feels flat or confusing, it's usually
missing one of the three — most often the conclusion. The section templates below are just C-C-C
instantiated for each part.

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

## Related work

- **Organize by theme, not paper-by-paper.** Group prior work by approach or research question — a bibliography with sentences is not related work.
- **Position, don't just list.** Say how each line relates to yours and where yours differs; the reader should leave with a map and your place on it.
- **Be precise and generous.** Misrepresenting or dismissing prior work is the fastest way to anger a reviewer — often a cited author.
- **Placement is venue-dependent**: right after the intro when readers need it to grasp the contribution; near the end when it would delay the payoff.

## Results / experiments

The section reviewers scrutinize hardest — make each result an argument, not a data dump.

- **One question per paragraph: question → evidence → answer.** Open with what the experiment tests, point to the figure/table, close with the claim it establishes. Each result rests on the last.
- **Every experiment maps to a stated claim.** If it tests nothing from the intro, cut it or say why it's here.
- **Order by importance**: headline comparison first (the result that carries the contribution), then ablations that isolate *why* it works, then robustness/sensitivity. Don't open on setup minutiae.
- **State the takeaway in words** — never make the reader infer the point from a table. Numbers support the sentence; they don't replace it.
- **Captions carry the takeaway too** — a caption should state its main finding in a line, and point to where it shows (the gap in the last column, the crossover at 10k steps). A skimming reviewer reads figures and captions before prose.
- **Push the periphery to the appendix.** Smaller ablations, sensitivity sweeps, and failure cases that don't move the paper's story belong in an appendix — reference them, but keep the main results section carrying only what advances the claim.
- **Report honestly**: variance / error bars, compute, failure cases. A confound a reviewer finds first is fatal.
- **Every number matches its source.** A value in the abstract, prose, or a table must equal what the results files say, and the same quantity must never appear with two different values in two places. Number drift across revisions is a reviewer red flag and trivially caught in review.

## Discussion, conclusion, limitations

- **Recap the one contribution** in a sentence — what to remember — then *interpret*, don't restate the results.
- **State limitations honestly and specifically.** Reviewers punish hidden weaknesses far harder than acknowledged ones; naming a limitation defuses it and signals judgment.
- **Why it matters / what's next** — concrete follow-ons, not the template "In future work we will explore various directions" (see AI-shaped prose).

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

## Citations must be real

LLM-assisted writing has made **fabricated citations** a common, reviewer-punished failure —
common enough that some venues now treat them as research misconduct. A citation can fail three
ways; verify every load-bearing one:

- **Existence** — the work is real. Models invent plausible-looking references: non-existent
  papers, phantom DOIs, fabricated arXiv IDs, invented author lists. Verify each against a
  **canonical index** — DBLP, arXiv, ACL Anthology, OpenReview, or a resolving DOI (CrossRef) —
  not the model's memory, and not a Google/Semantic Scholar snippet alone (those secondary
  sources are themselves contaminated).
- **Metadata** — right authors, year, title, venue. Watch arXiv-year vs. proceedings-year, title
  drift between versions, preprint mistaken for the official venue, and scrambled co-author order.
- **Context (the subtle, dangerous one)** — the cited paper actually supports the claim you
  attach to it. A *real* paper cited for something it doesn't show — or contradicts — is worse
  than a fake one: it survives an existence and metadata check and only a reader who knows the
  work catches it. For any claim a citation is carrying, read the source, not just its abstract.

Only the entries you actually `\cite` matter — a shared master `.bib` across projects will have
plenty of uncited entries, and that's fine. Check that every `\cite` resolves to a real key and
that the cited entry passes the three layers above. Run this as a dedicated pass **after the
bibliography is frozen**, right before submission — not on a moving draft. `\cite` *placement*
mechanics live in `latex-rules`.

**Verifying a citation** — only when the user explicitly asks to check one or all citations (this
is a slow web pass; never run it unprompted while drafting). For each entry, web-search until the
canonical record is found, then confirm authors/year/title/venue match the `.bib`:

- `[first-author surname] [year] [first 3 words of title]` — the general locate query.
- `"[full paper title]" site:semanticscholar.org OR site:arxiv.org` — exact-title match on an index.
- `[first author] [year] [venue/journal name]` — disambiguates when a title is generic or reused.
- `doi:[DOI]` — if the entry has a DOI (a resolving DOI ≈ existence confirmed).
- `arxiv:[arxiv-id]` — if the entry has an arXiv ID.

No canonical record after these → flag it as likely fabricated. A record found but with a
different author list, year, or venue → flag it as a metadata error, with the record's correct values.

**Never silently edit the `.bib`.** Report every proposed change — fabricated entries to remove,
metadata to correct, wrong-context citations to reconsider — as a list for the user to approve,
and check back before applying. The author is the one who can confirm which paper they actually
meant; a citation "fix" applied blind can swap in the wrong work.

## Mathematical writing

Goal: let the reader **follow**, not sound sophisticated. State assumptions *before* the
theorem; pair proofs with intuition (keep intuition in the main text, not only the
appendix); keep notation consistent; define every symbol at first use. **If a theorem is
restated in the appendix (or abstract/contributions), the restatement must match the main
one exactly** — case splits, quantifiers, assumptions, and variable names drift silently
across revisions, and a reviewer who spots the mismatch distrusts the whole proof.
Conventional
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
- **Vet every new or changed figure with the `tufte-vdqi` plugin** if it's installed — run its assess/checklist pass on the chart before committing to it. If the plugin isn't installed, you may offer to install it **once**; if the user declines, respect that and never ask again this session.

## Common mistakes → fixes

| Mistake | Fix |
|---|---|
| Intro > 1.5 pages | Move background to Related Work |
| Method buried late | Front-load the contribution |
| No contribution bullets | Add 2–4 concrete, falsifiable claims |
| Experiments not tied to claims | State what each experiment tests |
| Generic abstract opening | Start from the actual contribution |
| Related Work as paper-by-paper list | Reorganize by method family / research question |
| Results read as a data dump | Each paragraph: question → evidence → answer |
| Discussion restates the results | Interpret and draw implications instead |
| AI-generated / unverified citations | Verify existence, metadata, and that each source supports its claim (see Citations) |
| Inconsistent terminology | One name per concept |

## Pre-submission checklist

- [ ] Contribution stateable in one sentence; intro makes What / Why / So-What clear.
- [ ] Every major experiment supports a stated claim.
- [ ] Abstract follows the five-sentence formula with a quantitative result.
- [ ] Intro ≤ 1.5 pages; method appears by page 2–3; 2–4 contribution bullets.
- [ ] Limitations stated. Terminology consistent. No generic openings. Hedging trimmed.
- [ ] No AI-shaped prose: plain "is/has", no significance-tails, no false authority, no template future-work.
- [ ] Figures use vector graphics and self-contained captions.
- [ ] Every cited reference verified — exists (canonical index), correct metadata, supports its claim. Error bars / statistics reported; compute and code/data availability stated.
- [ ] Every number in prose/tables matches its source; no quantity stated two ways; restated theorems match the main statement.
- [ ] Results read as question → evidence → answer, headline first; discussion interprets rather than restates.

## Rebuttal

Reviews are in; space is **extremely** tight (often ~1 page) and responses move scores only marginally — be strategic and as short as possible. Cut every word that isn't load-bearing.

- **Tag each point with its reviewer** — begin every item with a bold, colored **R1** / **R2** / **R3** so each reviewer instantly finds where their concerns are addressed. Answer a shared concern once, but tag all the reviewers who raised it. (`latex-rules`' `packages.tex` ships `\Rone`…`\Rfour` for exactly this.)
- **Separate misunderstanding from real weakness.** For a misread, clarify in one line and point to where the paper says it (and fix that wording). For a real gap, add evidence — a new number, experiment, or analysis beats a paragraph of argument.
- **Don't deny a reduction — distinguish structurally.** When a reviewer says your method "reduces to X" or "is just generic Y," agree on the local reduction, then name the specific structural feature your approach preserves that X/Y does not — anchored to a concrete mechanism (a theorem dependency, a derivation step, an empirical consequence), never a bare assertion.
- **Surface non-obvious design choices yourself.** If the setup has a caveat a hostile reviewer could reverse-engineer (compute-matched ≠ epoch-matched, a frozen parameter subset, an atypical seed or hold-out protocol), name it plainly with numbers. Pre-empting the attack costs a line; being caught costs the reviewer's trust in everything else.
- **Lead with the highest-impact response**: new results first, then shared concerns.
- **Prioritize the swing reviewer** (borderline, engaged) — but don't ignore a negative one: rebut their points *for the swing reviewer's benefit*, showing concretely why the criticism is wrong so the swing reviewer doesn't absorb it and mark you down too.
- **Concede small points cheaply** to earn credibility on the ones you contest. Fighting everything reads as defensive.
- **Stay factual and courteous** — no wounded tone, no lecturing. Thank the reviewer, then answer.
- **Tiny figures/tables are fine here** — a small plot or 3-row table often beats a paragraph; reviewers can zoom in on the PDF.

For LaTeX mechanics (packages, cross-refs, tables, notation macros), use the
`latex-rules` skill.
