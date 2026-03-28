---
name: object
description: Convert specified files to object-oriented programming style. Accepts file names and optional natural language instructions.
user_invocable: true
---

# Object-Oriented Programming Conversion

Convert the specified files to an object-oriented programming style, appropriate to the language of each file.

## Core principles to apply

- Encapsulation: group related data and behaviour into classes or objects, hiding internal state behind well-defined interfaces
- Single responsibility: each class should have one clear purpose and reason to change
- Composition over inheritance: prefer composing objects from smaller, focused components rather than deep inheritance hierarchies
- Polymorphism: use interfaces, abstract classes, or protocols to define shared behaviour across different types
- Abstraction: expose only what consumers need, keep implementation details private
- Cohesion: keep related fields and methods together within the same class or module

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@file.ts`, `file.py`, `main.go, utils.go`, `script.sh handler.rb`
- Additional natural language instructions alongside file references, such as:
  - "and also convert the files imported by the specified file"
  - "focus only on the data processing logic"
  - "keep the existing function signatures as public methods"

Parse the arguments to identify which files to convert and what additional instructions apply. When additional instructions reference related files (e.g. imports, dependents), follow those instructions to identify and convert those files as well.

### Examples

- `/object @service.ts @handler.ts` — convert these two files
- `/object utils.py, helpers.py` — comma-separated, no `@` prefix
- `/object @app.go and also convert the files it imports` — convert with extended scope
- `/object @processor.rb focus only on the data transformation methods` — convert with targeted instructions

## How to proceed

1. Read each specified file to understand its current structure and language
2. If the user included additional instructions (e.g. "also convert imported files"), follow them to identify further files
3. For each file, apply the object-oriented principles above using idiomatic constructs for that file's language
4. Preserve the existing functionality — the conversion should not change what the code does, only how it is structured
5. Respect the repository's coding style rules while making the conversion
