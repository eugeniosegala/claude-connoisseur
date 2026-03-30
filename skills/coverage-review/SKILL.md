---
name: coverage-review
description: Analyse test coverage gaps and report uncovered code before making changes.
argument-hint: "[files] [instructions]"
user-invocable: true
disable-model-invocation: true
---

# Coverage Review

Analyse the project's test coverage, identify gaps, and present an assessment for the user to review before any changes are made. **Do not write or modify any code until the user provides next steps.**

Files and instructions: $ARGUMENTS

## What to detect

Before running anything, determine the test framework, runner, and coverage tooling by inspecting the project:

- **JavaScript/TypeScript**: `jest --coverage`, `vitest --coverage`, `c8`, `nyc`/`istanbul` — check `package.json` scripts, config files, and dev dependencies for coverage providers (`@vitest/coverage-v8`, `@vitest/coverage-istanbul`, `c8`, `nyc`)
- **Python**: `pytest --cov`, `coverage.py` — check `pyproject.toml`, `setup.cfg`, `.coveragerc`
- **Go**: `go test -cover`, `go test -coverprofile` — built-in
- **Rust**: `cargo tarpaulin`, `cargo llvm-cov` — check `Cargo.toml` dev-dependencies
- **Java/Kotlin**: `jacoco`, `cobertura` — check `pom.xml` or `build.gradle` plugins
- **Ruby**: `simplecov` — check `Gemfile`
- **Elixir**: `mix test --cover`, `excoveralls` — check `mix.exs`
- **PHP**: `phpunit --coverage-text` — check `phpunit.xml`, `composer.json`

If no coverage tool is installed, recommend one appropriate for the detected framework and ask the user before installing it.

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File or directory references to scope the analysis: `src/services/`, `@auth.ts`, `lib/`, `*.py`
- Natural language instructions such as:
  - "focus on the API layer"
  - "only check the utils module"
  - "ignore generated files"
  - "include integration tests"

When no arguments are provided, analyse coverage for the entire project.

### Examples

- `/coverage-review` — full project coverage analysis
- `/coverage-review src/services/` — coverage for a specific directory
- `/coverage-review @auth.ts` — coverage for a specific file
- `/coverage-review focus on the API handlers` — scoped by description
- `/coverage-review ignore generated files and vendor/` — with exclusions

## How to proceed

1. **Detect the framework and coverage tool**: read `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, or equivalent to identify available coverage tooling and its configuration
2. **Determine scope**: if the user specified files or directories, limit the analysis to those. Otherwise analyse the full project
3. **Run the coverage report**: execute the appropriate coverage command with text/summary output. Use flags that produce per-file and per-function breakdowns where available. Set a reasonable timeout (default 120s, extend for large suites)
4. **Parse the results**: extract file-level and function-level coverage data. Identify:
   - **Uncovered files** — source files with no corresponding tests at all
   - **Low-coverage files** — files below 50% line coverage
   - **Uncovered functions/methods** — specific functions with 0% coverage
   - **Uncovered branches** — conditional paths that are never exercised
5. **Read the uncovered code**: for each significant gap, read the source file to understand what the uncovered code does. Categorise each gap by risk and complexity:
   - **Risk**: how likely is a bug in this code to cause user-facing impact? (high / medium / low)
   - **Complexity**: how complex would the tests be to write? (simple / moderate / complex)
6. **Present the assessment**: report findings using the output format below. **Stop here and wait for the user's instructions before writing any code.**

## Output format

### Coverage assessment

```
## Coverage Assessment

**Framework**: vitest + @vitest/coverage-v8
**Scope**: full project (or scoped description)
**Overall line coverage**: 64% (target: 80%)

---

### Summary

| Category            | Count |
|---------------------|-------|
| Uncovered files     | 4     |
| Low-coverage files  | 6     |
| Uncovered functions | 12    |

---

### Uncovered files (no tests)

| File                          | Lines | Risk   | Complexity | What it does                          |
|-------------------------------|-------|--------|------------|---------------------------------------|
| `src/services/billing.ts`     | 142   | high   | moderate   | Stripe billing lifecycle management   |
| `src/utils/retry.ts`          | 38    | medium | simple     | Generic retry with exponential backoff|

### Low-coverage files (below 50%)

| File                          | Coverage | Uncovered functions              | Risk   | Complexity |
|-------------------------------|----------|----------------------------------|--------|------------|
| `src/handlers/auth.ts`        | 32%      | `refreshToken`, `revokeSession`  | high   | moderate   |
| `src/repos/order.ts`          | 45%      | `bulkUpdate`, `archiveOld`       | medium | complex    |

### Key uncovered branches

| Location                          | Branch description                       | Risk   |
|-----------------------------------|------------------------------------------|--------|
| `src/services/user.ts:52-58`      | Error path when email already exists     | high   |
| `src/handlers/auth.ts:91-95`      | Token expiry edge case                   | medium |

---

### Recommended priority

1. **`src/services/billing.ts`** — high risk, no tests at all, moderate complexity
2. **`src/handlers/auth.ts` → `refreshToken`, `revokeSession`** — high risk, auth-critical paths
3. **`src/services/user.ts:52-58`** — high risk branch, simple to cover
4. ...

---

What would you like to cover? You can point at specific files, pick from the priorities above, or ask me to cover everything.
```

### Cannot determine coverage tool

```
## Coverage Assessment: UNKNOWN

Could not detect a coverage tool. Looked for: jest/vitest coverage config, pytest-cov, coverage.py, go test -cover, cargo tarpaulin, jacoco, simplecov.

Recommended tool for this project: **[recommendation based on detected test framework]**

Would you like me to install and configure it?
```

### No gaps found

```
## Coverage Assessment: COMPLETE

**Overall line coverage**: 94%

All files are above 80% coverage. No significant uncovered functions or branches detected.

Minor gaps (cosmetic):
- `src/config/defaults.ts:12` — unreachable fallback branch
- `src/index.ts:3-5` — top-level bootstrap (not practically testable)
```

## Important notes

- **Do not write tests or modify code** — this skill produces an assessment only. Wait for the user to decide what to cover and how
- **Never run tests in watch mode** — it requires interactive input
- **Timeout handling** — if a coverage collection exceeds the timeout, report what is completed and that the run was interrupted
- **Sensitive output** — coverage output may contain file paths, connection strings, or credentials in error messages. Do not repeat these in the summary; replace with `[redacted]`
- **Respect existing configuration** — use the project's existing coverage config (thresholds, exclusions, reporters) rather than overriding with custom flags
- **Large projects** — if the project has hundreds of source files, focus the detailed analysis on the user-specified scope or the top 15 lowest-coverage files to keep the report actionable
