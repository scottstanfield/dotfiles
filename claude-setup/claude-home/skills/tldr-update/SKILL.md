---
name: tldr-update
description: Write a tight 2-3 sentence conceptual TLDR of recent progress, pulled from session context and the past day's commits. Use when the user asks for a "TLDR", "TLDR update", "progress update", "what got done", a standup blurb, or a status summary of recent work.
---

# TLDR Update

Produce a single short paragraph that says, conceptually, what changed — readable by someone who never saw the code.

## Gather

1. Recent commits (past day):
   ```
   git log --since="1 day ago" --pretty=format:"%h %s" --no-merges
   ```
   If that's empty, widen to `--since="2 days ago"`. If not a git repo, skip silently.
2. Session context — what this conversation actually worked on (decisions, fixes, features). This usually matters more than the commit messages.

Synthesize across both. Group the work by *what it means*, not by individual commit.

## Write

Draft the paragraph against these rules. All are hard constraints:

- **Sacrifice grammar for concision.** This is the defining rule, not a stylistic suggestion. Drop leading articles ("a", "the") and auxiliary verbs ("is", "was", "has been") wherever meaning survives. Prefer a dash to a conjunction - "X shipped - Y still open", not "X shipped and Y is still open". Cut any word the sentence reads fine without. A slightly clipped, telegraphic sentence is correct here; a smooth grammatical one usually means it wasn't compressed enough.
- **2-3 sentences. One paragraph.** No headers, no bullets, no lists.
- **BLUF.** First sentence is the concept or takeaway — the outcome that matters — not the mechanics of how it was built.
- **Conceptual, no jargon.** Describe the change in plain terms. Avoid function names, file paths, library names, flags, and ticket IDs. If a non-engineer couldn't follow it, rewrite.
- **Plain third person.** No "I", "we", "our", "the team".
- **No filler subjects.** Drop "the team built", "we made", "work was done". Let the work be the subject of the sentence.
- **One caveat, optional.** At most one honest limitation or open question. No second caveat.
- **No closer.** No motivational line, no slogan, no "next up" unless it's the single allowed caveat.

## Clean up

Always finish by running the `humanizer` skill on the drafted paragraph, then return the cleaned result as the final output.

One guard: humanizer smooths prose toward natural grammar, which fights the concision rule above. Keep the clipped, article-dropped, semicolon-joined style — let humanizer strip AI tells (inflated words, rule-of-three), but do not let it re-add dropped articles or auxiliaries, and do not let it convert the dash joiners back into conjunctions. The dashes here are deliberate compression, not the decorative em-dashes humanizer normally removes - keep them. Terseness wins ties.

## Example

> Returning users skip login now - sessions survive a restart instead of dying on close. Still falls back to fresh login when a stored session won't verify.

Note the dropped articles and auxiliaries ("Still falls back...", not "It still falls back..."), the dash in place of "and", and the single trailing caveat with no closer.
