---
name: functional
description: Convert specified files to functional programming style. Accepts file names and optional natural language instructions.
user-invocable: true
disable-model-invocation: true
---

# Functional Programming Conversion

Convert the specified files to a functional programming style, appropriate to the language of each file.

## Core principles to apply

- Pure functions: eliminate side effects, ensure functions return values based solely on their inputs
- Immutability: replace mutable state with immutable data structures and transformations
- Composition: prefer function composition and pipelines over imperative step-by-step logic
- Higher-order functions: use map, filter, reduce and similar constructs instead of manual loops
- Declarative style: express what should happen, not how to do it step by step
- Avoid shared mutable state: replace class-level or module-level mutable variables with function parameters and return values

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@file.ts`, `file.py`, `main.go, utils.go`, `script.sh handler.rb`
- Additional natural language instructions alongside file references, such as:
  - "and also convert the files imported by the specified file"
  - "focus only on the data processing functions"
  - "keep the existing class structure but make methods pure"

Parse the arguments to identify which files to convert and what additional instructions apply. When additional instructions reference related files (e.g. imports, dependents), follow those instructions to identify and convert those files as well.

### Examples

- `/functional @service.ts @handler.ts` — convert these two files
- `/functional utils.py, helpers.py` — comma-separated, no `@` prefix
- `/functional @app.go and also convert the files it imports` — convert with extended scope
- `/functional @processor.rb focus only on the data transformation methods` — convert with targeted instructions

## How to proceed

1. Read each specified file to understand its current structure and language
2. If the user included additional instructions (e.g. "also convert imported files"), follow them to identify further files
3. For each file, apply the functional programming principles above using idiomatic constructs for that file's language
4. Preserve the existing functionality — the conversion should not change what the code does, only how it is structured
5. Respect the repository's coding style rules while making the conversion
