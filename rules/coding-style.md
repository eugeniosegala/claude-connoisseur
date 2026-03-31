# Code Style & Modularity Rules

## Respect Repository Style
- Before writing or modifying code — including tests — read surrounding files to understand the existing conventions (naming, formatting, structure, comments, indentation).
- Match the style of the repository by default. Only introduce new patterns, naming conventions, or structural choices when explicitly requested or when the feature genuinely requires it.
- If the repo uses specific file naming schemes (e.g. numbered prefixes, grouped by concern), follow the same scheme.
- For tests specifically, follow the existing test structure, assertion style, naming patterns, and strategies (e.g. mocking, stubbing, fixtures, test data setup) rather than introducing new ones.

## Prefer Modern Syntax
- Use the latest language features and syntax unless there is a genuine reason not to (e.g. runtime constraints, compatibility requirements).
- Apply this principle to every language, not just the ones listed below. Always prefer the most modern idiomatic syntax available for the language in use. The following are a few examples:
  - **JavaScript/TypeScript**: prefer arrow functions over traditional function expressions, block-scoped declarations over var, optional chaining and nullish coalescing over manual checks, template literals over string concatenation, destructuring over repetitive property access, and async/await over Promise chains.
  - **Python**: prefer f-strings over older formatting methods, type hints throughout, pattern matching over long conditional chains, and dataclasses or structured models over plain dictionaries.
- If the repo already uses older syntax consistently, follow it — but prefer modern syntax for new code unless it would create jarring inconsistency within the same file.

## Comments
- Only add comments where the logic is not self-evident: complex algorithms, non-obvious workarounds, regular expressions, business rules with unusual constraints, or intentional deviations from the expected approach.
- Do not add comments that restate what the code already says. Avoid comments on straightforward variable assignments, simple conditionals, standard library usage, or well-named functions.
- If code needs a comment to be understood, first consider whether renaming or restructuring would make the comment unnecessary.

## Avoid Duplication
- Before creating any new code, search the codebase for existing implementations that solve the same or a similar problem.
- If similar logic already exists, reuse it — extend, parameterise, or refactor the existing code rather than duplicating it.
- Never copy-paste blocks of code across files. If the same logic is needed in multiple places, extract it into a shared module, function, or utility.

## Prefer Modularity
- Break functionality into small, focused, reusable units (modules, functions, classes) with clear inputs and outputs.
- Each unit should do one thing well and be independently testable.
- Shared logic should live in a dedicated location (e.g., `modules/`, `lib/`, `utils/`, `shared/`) appropriate to the repo's structure.

## Shareability
- Design reusable components to be configurable via variables/parameters rather than hardcoded values.
- Use sensible defaults so shared components work out of the box but can be customized when needed.
- Keep interfaces (inputs/outputs) well-defined and documented so others can use shared components without reading the implementation.

## Testing
- When writing or modifying code, always write or update corresponding tests.
- If tests already exist for the affected code, update them to reflect the changes.
- If no tests exist, create them.
- Run the relevant test suite to verify that all checks pass before considering the work complete.
