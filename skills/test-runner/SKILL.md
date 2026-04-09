---
name: test-runner
description: Run tests, fix failures, and re-run until the suite passes.
argument-hint: "[files] [instructions]"
user-invocable: true
context: fork
disable-model-invocation: true
---

# Test Runner

Run the project's test suite (or specific test files), diagnose failures, fix them, and re-run until all tests pass.

Files and instructions: $ARGUMENTS

## What to detect

Before running anything, determine the test framework and runner by inspecting the project:

- **JavaScript/TypeScript**: `jest`, `vitest`, `mocha`, `ava`, `tap`, `playwright`, `cypress` — check `package.json` scripts, config files (`jest.config.*`, `vitest.config.*`, `.mocharc.*`), and dev dependencies
- **Python**: `pytest`, `unittest`, `nose2`, `tox` — check `pyproject.toml`, `setup.cfg`, `tox.ini`, `Makefile`, or `pytest.ini`
- **Go**: `go test` — check for `*_test.go` files
- **Rust**: `cargo test` — check for `Cargo.toml`
- **Java/Kotlin**: `mvn test`, `gradle test` — check `pom.xml` or `build.gradle`
- **Ruby**: `rspec`, `minitest` — check `Gemfile`, `.rspec`, `Rakefile`
- **Shell**: `bats` — check for `*.bats` files
- **Elixir**: `mix test` — check `mix.exs`
- **PHP**: `phpunit` — check `phpunit.xml`, `composer.json`

If multiple frameworks exist, run the one most relevant to the specified files — or all of them if no files are specified.

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@service.test.ts`, `tests/unit/`, `test_*.py`, `*_test.go`
- Additional natural language instructions alongside file references, such as:
  - "only run the unit tests"
  - "run with coverage"
  - "focus on the auth module tests"
  - "run the tests I just changed"
  - "fix the source code, not the tests"

When no arguments are provided, run the full test suite.

### Examples

- `/test-runner` — detect the framework and run the full suite
- `/test-runner @service.test.ts` — run a specific test file
- `/test-runner tests/unit/` — run all tests in a directory
- `/test-runner only the tests related to authentication` — find and run auth tests
- `/test-runner fix the source code, not the tests` — fix implementation bugs instead of updating test expectations

## How to proceed

1. **Detect the framework**: read `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `Gemfile`, or equivalent to identify the test runner and its configuration. Check for custom test scripts (e.g. `npm test`, `make test`)
2. **Determine scope**: if the user specified files or directories, run only those. Otherwise run the full suite. If the user said "run the tests I just changed", use `git diff --name-only` to find recently modified test files
3. **Build the command**: construct the appropriate test command for the detected framework. Include flags for:
   - Verbose output (to capture individual test names and statuses)
   - No colour codes where possible (cleaner parsing)
   - Coverage only if explicitly requested
   - Fail-fast only if explicitly requested
4. **Run the tests**: execute via Bash. Set a reasonable timeout (default 120s, extend for large suites)
5. **Diagnose failures**: for each failing test, read the test file and the source code it exercises. Determine whether the failure is caused by:
   - A bug in the source code (the test expectation is correct but the implementation is wrong)
   - A stale or incorrect test (the implementation is correct but the test needs updating)
   - A missing mock, fixture, or setup issue
   - An environment or configuration problem
6. **Fix the failures**: apply the appropriate fix:
   - If the source code is wrong, fix the source code
   - If the test is stale or incorrect, update the test
   - If mocks or fixtures are missing, add them — following existing patterns in the codebase (search for how other tests mock the same dependencies before creating new mocks)
   - If the user explicitly said what to fix (e.g. "fix the source code, not the tests"), respect that
7. **Re-run the tests**: after applying fixes, re-run the failing tests to verify they pass. If new failures appear, repeat steps 5–7. Stop after 3 full iterations to avoid infinite loops — if tests still fail after 3 rounds, report the remaining failures
8. **Report back**: present results in the format below

## Output format

### All tests pass (no fixes needed)

```
## Test Results: PASS

Ran **42 tests** in 3.2s — all passed.
```

### All tests pass (after fixes)

```
## Test Results: PASS (after fixes)

Ran **42 tests** in 4.1s — all passed after fixing 3 failures.

### Fixes applied

1. **`src/services/user.ts:52`** — added uniqueness check before insert (was missing, causing `UserService.create › should reject duplicate emails` to fail)
2. **`src/handlers/__tests__/auth.test.ts:102`** — updated expected status from `429` to `200` (rate limiter was removed in v2.3)
3. **`src/repos/order.ts:34`** — passed `limit` parameter to the query builder (was being ignored)
```

### Tests still failing (after 3 rounds)

```
## Test Results: FAIL (after 3 fix rounds)

Ran **42 tests** in 6.2s — **1 still failing**, 2 fixed, 39 passed.

### Remaining failures

1. **`IntegrationTest.externalAPI › should retry on timeout`**
   `tests/integration/api.test.ts:89`
   Requires a running mock server on port 8080 — cannot fix automatically.

### Fixes applied

1. **`src/services/user.ts:52`** — added uniqueness check before insert
2. **`src/handlers/__tests__/auth.test.ts:102`** — updated expected status code
```

### Cannot determine framework

```
## Test Results: UNKNOWN

Could not detect a test framework. Looked for: package.json, pyproject.toml, Cargo.toml, go.mod, pom.xml, Gemfile.

Please specify how to run tests (e.g. `/test-runner npm test` or `/test-runner pytest tests/`).
```

## Important notes

- **Never run tests in watch mode** — it requires interactive input. If the user asks for watch mode, explain why it cannot run in this context and offer to run once instead
- **Prefer fixing source code over weakening tests** — unless the test expectation is clearly wrong or the user says otherwise, assume the test is correct and fix the implementation
- **Search for existing patterns before adding mocks** — use Grep to find how other tests mock the same dependency. Reuse the established approach
- **Timeout handling** — if tests exceed the timeout, report which tests completed and that the run was interrupted
- **3-round limit** — stop after 3 fix-and-rerun cycles. Report remaining failures without further attempts
