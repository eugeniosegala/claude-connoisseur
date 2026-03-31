---
name: proofread
description: Fix grammar and improve writing while preserving the author's original voice and style.
argument-hint: "<files> [instructions]"
user-invocable: true
disable-model-invocation: true
---

# Proofread

Fix grammar and improve writing in the specified files while keeping the author's original voice intact.

Files and instructions: $ARGUMENTS

## Core principles to apply

- Fix grammar, spelling, and punctuation errors, but do not rewrite the author's style
- Always use British English (e.g. "colour", "organisation", "behaviour", "analyse")
- Never use dashes (em dashes, en dashes, or similar). Restructure into separate sentences or use commas, colons, or parentheses instead
- Keep the tone direct and concise, but never rude or disrespectful
- Do not over-polish. The writing should feel human and relatable, not robotic or corporate
- Preserve the author's sentence rhythm, word choices, and personality. If the original is casual, keep it casual. If it is blunt, keep it blunt
- Do not add filler words, hedging language, or unnecessary qualifiers
- Do not introduce AI-typical patterns: no "it's important to note", "in order to", "leverage", "utilise", "delve into", "it's worth mentioning", or similar

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@README.md`, `docs/guide.md`, `CHANGELOG.md, CONTRIBUTING.md`
- Additional natural language instructions alongside file references, such as:
  - "focus on the introduction section"
  - "also fix the comments in the code"
  - "keep technical terms as they are"

Parse the arguments to identify which files to proofread and what additional instructions apply. When additional instructions reference related files, follow those instructions to identify and process those files as well.

### Examples

- `/proofread @README.md` — proofread this file
- `/proofread docs/guide.md, docs/setup.md` — proofread multiple files
- `/proofread @SKILL.md focus on the description sections only` — proofread with targeted scope
- `/proofread @blog-post.md keep all code examples exactly as they are` — proofread with constraints

## How to proceed

1. Read each specified file to understand the content and the author's writing style
2. If the user included additional instructions (e.g. "focus on the introduction"), follow them to narrow the scope
3. Fix grammar, spelling, and punctuation errors throughout
4. Replace any dashes with alternative punctuation or restructured sentences
5. Ensure British English spelling is used consistently
6. Review the result to confirm the author's original voice and tone have been preserved
