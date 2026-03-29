---
name: test-refactor
description: Refactor tests for consistency, mocking patterns, isolation, and quality.
argument-hint: "<files> [instructions]"
user-invocable: true
disable-model-invocation: true
---

# Test Refactor

Refactor the specified test files to improve consistency, mocking patterns, isolation, and overall quality.

Files and instructions: $ARGUMENTS

## Core principles to apply

- **Mocking consistency**: before changing anything, search the codebase for how other tests mock the same dependencies. Adopt the established pattern. If tests in the project use a specific helper, factory, or mock setup for a dependency, reuse it — do not invent a new way to mock the same thing.
- **Mock scope**: replace over-broad mocks with targeted ones (mock only what's needed, not the entire module). Remove mocks of the unit under test. Ensure mocks are cleaned up after each test.
- **Test isolation**: eliminate shared mutable state between tests. Move shared setup into `beforeEach` (not `beforeAll` unless truly static). Remove order dependencies between tests.
- **Assertion quality**: replace weak assertions (`toBeTruthy`, `assert result`) with specific ones (`toBe(expectedValue)`, `assertEqual(result, expected)`). Add missing assertions where code runs but nothing is verified.
- **Test structure**: apply arrange-act-assert. Split tests that verify multiple things into focused, single-assertion tests. Improve test names to describe the scenario and expected outcome.
- **Test data**: extract hardcoded magic values into named constants or factory functions. Reuse existing test fixtures and builders from the project instead of duplicating setup.
- **Flaky patterns**: replace time-dependent logic with mocked clocks. Replace network/filesystem dependencies with stubs. Remove non-deterministic ordering assumptions.
- **Framework misuse**: fix incorrect use of testing framework features (e.g. `beforeAll` when `beforeEach` is needed, missing `await` on async assertions, wrong matcher usage).

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@service.test.ts`, `test_handler.py, test_utils.py`, `*_test.go`
- Additional natural language instructions alongside file references, such as:
  - "align mocking patterns with the tests in tests/unit/"
  - "focus only on mocking consistency"
  - "we use vitest and msw for mocking"
  - "also refactor the shared test helpers if needed"

Parse the arguments to identify which files to refactor and what additional instructions apply. When additional instructions reference related files (e.g. other test files, test helpers), follow those instructions to identify and include those files as well.

### Examples

- `/test-refactor @service.test.ts` — refactor a single test file
- `/test-refactor tests/unit/` — refactor all tests in a directory
- `/test-refactor @handler.test.ts align mocking patterns with tests/unit/auth.test.ts` — match existing patterns
- `/test-refactor @api.test.py focus on mocking consistency and test isolation` — targeted refactor
- `/test-refactor @service.test.ts also refactor the shared test helpers if needed` — refactor with extended scope

## How to proceed

1. Read each specified test file to understand the testing framework, patterns, and structure
2. If the user included additional instructions (e.g. "align with other tests"), follow them to identify further files
3. Search the codebase for other test files that mock the same dependencies — use `Grep` to find established mocking patterns, factories, and test helpers. This step is critical: never refactor mocks without first understanding the project's existing conventions
4. For each file, apply the core principles above — prioritising mocking consistency with the rest of the codebase
5. Preserve the existing test coverage — the refactor should not change what is tested, only how the tests are structured
6. Respect the repository's coding style rules while making the refactor
