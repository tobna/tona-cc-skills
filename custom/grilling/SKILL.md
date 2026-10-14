---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Open with a one-line plan of the themes you expect to cover, e.g. *Plan: scope, data, training, evaluation*. If it is not clear which theme comes first, ask the user where to start.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Each round takes one **theme** from the frontier: a few questions on the same topic, starting with the theme most other decisions hang off. Keep rounds small; the rest of the frontier waits for later rounds. Then wait for the user's answers.

Ask in plain chat text, not through a question or picker tool, so the user can answer however they like. Format a round like so:

```
#### Round <n> · <theme>

> ❓ **<n>.<k> · <question title>**
> <question body>
> - **a)** <option>
> - **b)** <option>
>
> 💡 **<suggested option or answer>**: <one-line reason>
```

Number questions `<round>.<question>`. A question keeps its ID when it is asked again later.

Offer options when the answer is one of a few known alternatives. Leave the question open, without options, when the answer is the user's to put into words: goals, priorities, taste, names, what counts as done. Either way, end with a 💡 suggestion, worded so the user can answer "yes" or an option letter and move on. They may also ignore it and answer in their own words.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and pick the next theme. A question whose answer depends on another open question belongs to a later round.

A question the user leaves unanswered stays open. Do not treat it as accepting the 💡: the user may have postponed it or not be sure yet. Ask it again later, in a round where it fits, not necessarily the next one.

Finding _facts_ is your job, never the user's. When a question needs a fact from the environment (filesystem, tools, etc.), look it up yourself rather than asking. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Close with a short summary of the settled decisions, by ID. Do not suggest a next step; the user knows what to do with it. Do not act on it until the user says so.
