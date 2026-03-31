---
name: learnify
description: Isolate a function or code block into a self-contained, runnable script for study and manual testing.
argument-hint: "<files> [instructions]"
user-invocable: true
disable-model-invocation: true
---

# Learnify — Isolate Code for Learning

Extract the specified function or code block into a standalone, self-contained script designed for study and hands-on experimentation.

Files and instructions: $ARGUMENTS

## Goals

- Produce a single runnable script that works without the original codebase
- Make the code easy to understand, modify, and experiment with
- Allow the reader to study the logic, tweak inputs, and observe outputs in isolation

## What the generated script should include

- **The target code**: the function or code block the user specified, copied verbatim as the starting point
- **Inlined dependencies**: any helpers, types, constants, or utilities the target code depends on — inlined directly rather than imported, so the script is fully self-contained. Third-party modules (e.g. `lodash`, `axios`, `requests`, `pandas`, `numpy`) should remain as imports — only inline code from the project itself
- **Comments**: add clear, educational comments explaining what the code does, why it works the way it does, and any non-obvious details — treat the reader as someone trying to learn from this code
- **Example invocations**: concrete calls to the function with realistic sample inputs, covering typical usage and interesting edge cases
- **Printed output**: log or print the results of each invocation so running the script immediately shows what the code produces
- **Editable inputs section**: group sample inputs near the top of the script so the reader can easily swap in their own values and re-run

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@file.ts`, `file.py`, `main.go, utils.go`, `script.sh handler.rb`
- Natural language describing what to isolate, such as:
  - "the calculateTax function"
  - "the retry logic in the fetch wrapper"
  - "the validation pipeline"
- Additional instructions, such as:
  - "include the helper functions it calls"
  - "add comments explaining the recursion"
  - "show edge cases with empty inputs"

Parse the arguments to identify which file(s) to read, what code to extract, and what additional instructions apply.

### Examples

- `/learnify @utils.ts the calculateTax function` — extract calculateTax into a runnable script
- `/learnify @parser.py the tokenize and parse functions` — extract multiple related functions
- `/learnify @api.go the retry logic, include comments explaining the backoff strategy` — extract with targeted instructions
- `/learnify @auth.rb the password hashing flow, show edge cases` — extract with edge case examples

## How to proceed

1. Read the specified file(s) to understand the code and its language
2. Identify the target function or code block based on the user's description
3. Trace its dependencies — any helpers, constants, types, or utilities it calls — and prepare to inline them
4. Generate a new script file in the same language that:
   - Inlines all dependencies so nothing is imported from the original codebase
   - Adds educational comments throughout
   - Includes an editable inputs section near the top
   - Calls the function with realistic sample inputs and prints the results
   - Runs immediately with no setup (e.g. `node script.js`, `python script.py`)
5. Save the script to a sensible location (e.g. alongside the original file or in a `playground/` directory) and tell the user how to run it
