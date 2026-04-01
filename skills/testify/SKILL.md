---
name: testify
description: Write and improve tests — reuse existing patterns, ensure consistency, and maintain quality.
argument-hint: "[files] [instructions]"
user-invocable: true
disable-model-invocation: false
---

# Testify

Write new tests or improve existing ones, always reusing the project's established testing patterns, style of writing, mocks, and fixtures.

Files and instructions: $ARGUMENTS

## Core principles

### Reuse before creating

- Before writing any mock, fixture, factory, or helper, search the codebase for how other tests solve the same problem. If the project already has a pattern for it, use it
- Follow the mocking strategy already established (module mocks, dependency injection, HTTP interception, etc.). Only introduce a different approach when the existing one genuinely cannot cover the case
- Reuse existing test data builders and factories. If no factory exists and the same setup appears in multiple places, extract one into the project's shared test utilities

### Mocking

- Mock only what is needed — not the entire module. Keep mocks scoped to the dependency being isolated
- Do not mock the unit under test
- Clean up mocks after each test to prevent leakage between tests

### Structure and isolation

- Apply arrange-act-assert. Each test should verify a single behaviour
- Name tests to describe the scenario and expected outcome, not the implementation detail
- Eliminate shared mutable state between tests. Use per-test setup (`beforeEach`) over shared setup (`beforeAll`) unless the data is truly static
- Remove order dependencies between tests

### Assertions

- Use specific assertions (`toBe(expected)`, `assertEqual(result, expected)`) over vague ones (`toBeTruthy`, `assert result`)
- Every test should verify a concrete outcome — if code runs but nothing is asserted, add the missing assertion

### Test data

- Extract hardcoded magic values into named constants or factory functions
- Reuse existing fixtures and builders from the project instead of duplicating setup

### Robustness

- Replace time-dependent logic with mocked clocks
- Replace network/filesystem dependencies with stubs
- Remove non-deterministic ordering assumptions
- Fix incorrect framework usage (e.g. `beforeAll` when `beforeEach` is needed, missing `await` on async assertions, wrong matcher usage)

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@service.test.ts`, `test_handler.py, test_utils.py`, `*_test.go`
- Source files that need tests written: `@auth.ts write tests for this`, `src/services/`
- Natural language instructions such as:
  - "align mocking patterns with the tests in tests/unit/"
  - "focus only on mocking consistency"
  - "write tests for the new endpoints"
  - "also refactor the shared test helpers if needed"

Parse the arguments to identify which files to work on and what additional instructions apply. When instructions reference related files (e.g. other test files, test helpers), follow them to identify and include those files as well.

When no arguments are provided, this skill is being invoked by the model — apply the principles above to whatever test code is currently being written.

### Examples

- `/testify @service.test.ts` — improve an existing test file
- `/testify @auth.ts write tests for this` — write new tests for a source file
- `/testify tests/unit/` — improve all tests in a directory
- `/testify @handler.test.ts align mocking patterns with tests/unit/auth.test.ts` — match existing patterns
- `/testify @api.test.py focus on mocking consistency and test isolation` — targeted improvement
- `/testify write tests for the functions I just added` — cover recent work

## How to proceed

1. **Understand the context**: read the specified files (test files, source files, or both) to understand the testing framework, patterns, and structure
2. **Search for existing patterns**: find how other tests in the project mock the same dependencies, set up data, and structure assertions. This step is critical — never write mocks or setup without first understanding the project's conventions
3. **If the user included additional instructions** (e.g. "align with other tests"), follow them to identify further files to read
4. **Write or improve tests**:
   - **New tests**: follow the project's existing test structure, naming conventions, and mocking patterns. Place test files where the project expects them
   - **Existing tests**: apply the core principles above — prioritise reusing established patterns over introducing new ones. Preserve what is tested; improve how it is tested
5. **Respect the repository's coding style rules** while making changes
