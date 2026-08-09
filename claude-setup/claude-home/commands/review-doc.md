Review a document and propose concrete improvements.

Document: $ARGUMENTS

`$ARGUMENTS` is a path to a local document (Markdown, text, etc.). If it's
empty or not a readable file, ask the user to paste the document content or
give a path, then stop until they do.

## Steps

### 1. Read the document
Read the full file and keep it as context. Note its purpose and audience from
the content (design doc, README, proposal, spec, blog post, …).

### 2. Find review points
Read critically and collect specific, actionable issues. Look for:
- **Correctness** — claims that are wrong, outdated, or unsupported
- **Gaps** — missing steps, undefined terms, unanswered questions a reader
  would have
- **Clarity** — ambiguous or confusing sentences; buried key points
- **Structure** — ordering, headings, or sections that don't flow
- **Consistency** — contradictions, mismatched terminology
- **Tone/style** — anything off for the intended audience

Skip nitpicks that don't change meaning unless the user asked for a copy edit.
If the document is solid, say so and jump to the summary.

### 3. Review each point one-by-one
For each issue:

**a) Assess:** classify it as `correctness`, `gap`, `clarity`, `structure`,
`consistency`, or `style`. Quote the exact sentence/section it applies to.

**b) Propose a fix** using these tone/style rules:
- Keep explanations short — 3-5 sentences max
- Cite the specific section/heading you're referring to
- Show a concrete before/after snippet for any edit (what to change and where)

**c) Present to the user.** Show:
1. The location (heading + quoted text)
2. Your assessment (category + why it matters)
3. The proposed edit (before/after)

Then ask, using AskUserQuestion:
- **Apply as-is** — make the edit to the document
- **Edit and apply** — let the user adjust the wording, then apply
- **Skip** — move on without changing anything

Wait for the user's choice before moving to the next point.

### 4. Summary
After all points, output a markdown table:

| # | Location | Category | Action Taken |
|---|----------|----------|--------------|

Where Action Taken is one of: `applied`, `edited + applied`, `skipped`.
