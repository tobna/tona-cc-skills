---
name: slidewriting
description: The Slidewriting method for building a talk deck — storyboard, action titles, framing, then real slides, stopping for the user's feedback after each step. Use when making, revising, or reviewing slides for a talk or a presentation.
---

# Slidewriting

A method for building a deck for a research talk. It comes from the Slidewriting
seminar (Dr. Markus Burger, Fraunhofer), adapted here for academic talks.

The slides have two jobs. They support you while you speak, and they stand on their
own afterwards on a website. Support during the talk wins whenever the two conflict.
The method handles both because the argument sits on the slide as structure rather
than as prose: the title states the claim, the framing draws its shape, and you supply
the connecting words out loud.

## Work in four steps, and stop after each one

1. Storyboard
2. Mickey-mouse-flow
3. Dummy slides
4. Real slides

**After each step, show the user what you produced and stop. Do not begin the next
step until they explicitly tell you to.** Every step is cheap to redo and expensive to
skip past. A wrong storyboard that reaches the real-slides step has wasted all four.
Do not run two steps in one turn, and do not treat silence, a short acknowledgement,
or a question about the current step as permission to continue.

### 1. Storyboard

Settle the goal, the audience, and the time budget before anything else. The goal is
the one thing the audience should be able to repeat a week later. Say it in a sentence.
If you cannot, the talk is not ready and slides will not fix it.

Then write the key question each slide answers. Questions, not answers, and nothing
else yet.

Budget roughly 1 to 1.5 minutes per slide, so a 20 minute slot, which is really about
17 minutes of talking, gives 12 to 15 slides. Build-up steps within a slide are free
and do not count.

A key question sometimes needs several slides to answer step by step. Give each
question a slide budget, and this is where the scope argument happens: six questions
and fifteen slides means deciding which question gets four slides and which gets one.
That decision is far cheaper here than later.

**Show the user:** the goal in one sentence, and the list of key questions with the
slide budget for each. Nothing else. Then stop.

### 2. Mickey-mouse-flow

Answer each key question with an action title. These are provisional claims, and they
will change.

Read the action titles top to bottom. That sequence is the talk's abstract, and it
should hold together as an argument on its own. If it reads as a table of contents,
the deck has no story yet and no amount of design will give it one. This is the
cheapest point at which a broken talk can be caught, so do not rush it.

Titles within a run of slides answering one question must chain: pick up words from
the previous title, using the same words rather than synonyms.

**Show the user:** the action titles as continuous prose, in order. Then stop.

### 3. Dummy slides

Sketch the framing for each slide. Take the action title, replace its content nouns
with variables, and see what schema is left. That schema is the framing. The verb
carries the relation, so the verb decides the shape.

Sketch only. Boxes, arrows, groupings, and where the content will sit. No real
content, no styling.

Framing does not apply everywhere. Some slides are a table of results, and boxes drawn
around a table are decoration. Try the framing first on every slide and drop it when
there is nothing to draw, rather than reaching for the plain version by default.

**Show the user:** one line per slide describing the framing. Then stop.

### 4. Real slides

Fill the content into the framing. Follow the design rules below.

**Show the user:** the slides. Then stop.

## Anatomy of a slide

Three parts, in this order down the slide.

**Action title.** The slide's main point, as one full sentence, top left.

- At most 10 words in English, 8 in German.
- Active verb. The mood carries meaning: indicative for how things are, subjunctive
  for what could be, imperative for what should happen.
- Plain and declarative. "Transformer X is 10% faster than Y." "The project consists
  of five subprojects." Dull is correct here. Titles that sound clever usually say
  less than they appear to.
- Every slide gets one, including a bare results table, which still has to say what it
  shows.

**Framing.** A drawing of the title's logical structure, sitting between the title and
the content. Boxes, arrows, groups. It lets a reader zoom in on one part of the
argument without losing the whole. A pure list is never a framing, because a list
shows no relations.

Lists are allowed when they label a structure that something else is carrying. The
check: remove the images or the diagram and see whether the list still makes the same
point. If it does, it was a pure list and the images were decoration.

**Content.** The evidence for the title, placed inside the framing. Tables, plots,
text, equations. Use a repeating format across slides that carry the same kind of
evidence.

Optionally a **locator** naming where you are in the deck, and the source and author
lines. For talks under about 30 minutes a locator is enough. Longer than that, use a
divider slide repeating the agenda. A locator is a short phrase, as specific as you can
make it, and it names the key question the current run of slides answers.

## Schema library

Strip the action title down to variables and match it here. The set is a starting
point; extend it by the same move rather than treating it as closed.

| Action title | Framing |
| --- | --- |
| X has Y | X on one side, Y broken out as numbered parts |
| X contains Y | Y drawn inside X |
| X implies Y | X, arrow, Y |
| X leads to Y | X, arrow, Y, with the numbered steps along the way |
| A leads to B via X | A, through X, to B |
| X transforms A into B | A entering X, B leaving it |
| X follows from A, B and C | A, B and C converging on X |
| X contradicts Y | X and Y opposed, the conflict marked between them |
| X1 leads to Y1 | two parallel columns, each X matched to its Y |
| Comparing X and Y yields Z | X and Y side by side, both feeding into Z |
| Each X yielded Y | rows of X against a results column |
| All X improve Y and Z | matrix of X against Y and Z, marked per cell |
| N questions need decisions | questions in a column, decision marks beside them |

## Holding the deck together

- Repeat words across the three levels of a slide and across slides. Never use a
  synonym for something you have already named. Synonyms force the reader to check
  whether you mean a new thing.
- Every statement works toward the goal from step 1. A slide that does not is cut, not
  shortened.
- Wrap the deck in an intro and an outro.
- End on the message, not on a "Questions?" slide. The last slide stays up through the
  whole discussion, so give it something worth looking at.
- If you could not say everything on a slide out loud within its 1 to 1.5 minutes, part
  of it is decoration.

## Design rules

These apply when building the real slides, and to a lesser extent when sketching
dummies.

**Color.** Text in grayscale. Color marks data and the one thing you are pointing
at, and spending it elsewhere spends it on nothing. Around 8% of men have a color
vision deficiency, so a conference audience always includes some: vary lightness and
not only hue, never carry meaning by color alone, and avoid red against green. Pick one
accent color for the deck and derive tints from it rather than adding hues; two or
three outside the data is plenty. Cool colors recede and work well in backgrounds;
warm colors come forward, so put them on whatever you want the audience to look at.
The Wong palette is a safe default for data series:

```
#000000  #E69F00  #56B4E9  #009E73  #F0E442  #0072B2  #D55E00  #CC79A7
```

**Contrast.** 4.5:1 for body text, 3:1 for large text. Commit to dark on light or
light on dark. Assume the projector is worse than your monitor, because it will be.

**Type.** Sans-serif. Large, and the main reason for large type is that it limits how
much fits on the slide. Around 24pt for body text and 28 to 36pt for titles works for
a projected 16:9 slide, but treat that as a starting point rather than a rule. Check it the way you
would check a billboard: standing at the back of the room, the point of the slide
should arrive within a couple of seconds. If it does not, the slide is too dense,
whatever the point size says.

**Geometry.** Title, content box, and margins in the same place on every slide.
Inconsistent placement reads as noise even when each slide is fine alone. Within a
slide, line every element up with something else rather than placing it by eye. A
stray centered caption is the usual tell.

**Grouping.** Spacing carries meaning. What belongs together sits close, what does not
gets space. Reach for this before reaching for boxes: whitespace groups as well as a
drawn container does, and a framing built from spacing is usually cleaner than one
built from rectangles.

**Chrome.** Remove per-slide logos, navigation buttons, progress bars, and decorative
rules. Keep slide numbers, and the locator or divider.

**Figures.** Rebuild them at slide scale rather than pasting from the paper. Three
operations, in that order: restrain the figure to the data the claim needs, reduce what
survives by deleting gridlines, frames, legends and the figure title, then emphasize
the part the claim is about. Vector output, larger labels, thicker lines. Anything cut
goes on a backup slide. Label curves directly and put each label beside the thing it
names.

**Progressive reveal.** Good, and worth using. Building the framing up in step with
what you are saying keeps the slide and your speech in sync. Build the argument's
structure, not decoration, and export a collapsed version for the standalone deck. An
effect loses force the more it is used, so a deck where every slide builds has no
builds at all.

## Related skills

- `tufte-vdqi` for chart type, encoding, and data visualization questions once a slide
  carries a plot.
- `paper-writing` for the narrative framing behind step 1, and for citation integrity.
- `humanizer` for any prose that ends up on a slide or in a handout.
