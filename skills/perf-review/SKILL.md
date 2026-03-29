---
name: perf-review
description: Review code for performance issues — complexity, batching, caching, memory, and concurrency.
argument-hint: "<files> [instructions]"
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# Performance Review

Analyse the specified files for performance issues and provide actionable improvement suggestions.

Files and instructions: $ARGUMENTS

## What to review

- **Algorithmic complexity**: inefficient loops, nested iterations that could be flattened, O(n^2) or worse patterns that could be reduced, unnecessary repeated computations
- **Batching**: operations that could be grouped (database queries, API calls, file I/O) instead of executed one at a time in a loop
- **Caching**: repeated expensive computations or lookups that would benefit from memoisation or caching, missing cache invalidation
- **Data structures**: use of the wrong data structure for the access pattern (e.g. linear search in a list where a set or map would be O(1), arrays where linked lists are better or vice versa)
- **Memory**: unnecessary allocations, large objects held longer than needed, string concatenation in loops, unbounded collections, missing pagination
- **Concurrency**: sequential operations that could run in parallel, blocking calls on the main thread, missing async/await, thread-safety issues that force unnecessary serialisation
- **I/O efficiency**: chatty network calls, missing connection pooling, unbuffered reads/writes, missing streaming for large payloads
- **Lazy vs eager evaluation**: eagerly loading or computing data that may never be used, missing short-circuit evaluation, loading entire datasets when only a subset is needed
- **Hot paths**: performance-critical code paths where micro-optimisations matter — unnecessary object creation, redundant type conversions, avoidable regex compilation
- **Language-specific antipatterns**: idioms that are idiomatic but slow in the specific language (e.g. reflection in Java, dynamic dispatch where static would suffice, unintentional boxing)

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@file.ts`, `file.py`, `main.go, utils.go`, `script.sh handler.rb`
- Additional natural language instructions alongside file references, such as:
  - "and also review the files imported by the specified file"
  - "focus only on database query performance"
  - "this handles 10k requests per second"
  - "we're seeing high memory usage in production"

Parse the arguments to identify which files to review and what additional instructions apply. When additional instructions reference related files (e.g. imports, dependents), follow those instructions to identify and review those files as well.

### Examples

- `/perf-review @service.ts @handler.ts` — review these two files
- `/perf-review utils.py, helpers.py` — comma-separated, no `@` prefix
- `/perf-review @app.go and also review the files it imports` — review with extended scope
- `/perf-review @api.ts focus only on database query performance` — targeted review
- `/perf-review @processor.rb we're seeing high memory usage in production` — review with context

## How to proceed

1. Read each specified file to understand its current structure, language, and purpose
2. If the user included additional instructions (e.g. "also review imported files"), follow them to identify further files
3. Analyse the code against every review category listed above
4. For each finding, provide:
   - **What**: the specific issue and where it occurs
   - **Why**: the performance impact (time complexity, memory, latency, throughput)
   - **Fix**: a concrete code change to resolve it
5. Group findings by category and order by expected impact (highest first)
6. If the runtime or framework is known, tailor recommendations to its specific performance characteristics and best practices

## Additional resources

- [checklist.md](checklist.md) contains language-specific antipatterns and concrete examples organised by the same review categories above. Use it as a supplementary reference after applying the main review process — it does not replace the categories and analysis defined in this skill.
