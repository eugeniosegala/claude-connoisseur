# Claude Connoisseur

<p align="center">
  <img src="assets/claude-connoisseur.png" alt="Claude Connoisseur" width="300" />
</p>

A collection of skills, rules, hooks and more for Claude Code, curated with taste for good coding!

## Installation

Add the marketplace and install the plugin from within Claude Code:

```
/plugin marketplace add eugeniosegala/claude-connoisseur
/plugin install claude-connoisseur@eugeniosegala-claude-connoisseur
```

### Updating

Third-party plugins do not auto-update by default. To get the latest version:

```
/plugin update claude-connoisseur@eugeniosegala-claude-connoisseur
```

To enable auto-updates, open `/plugin` → **Marketplaces** tab → select the marketplace → **Enable auto-update**.

### Notes

- Skills are shown as `/codex-review`, `/functional`, etc. in the command palette. The full namespaced form (
  `/claude-connoisseur:codex-review`) also works if you need to disambiguate from other plugins.
- The auto-format hook runs automatically after every `Write` or `Edit` — formatters are detected at runtime, so if a
  formatter isn't installed it is silently skipped.
- Rules are not distributed via the plugin system. To use the coding-style rule, copy it manually into your project:
  ```sh
  mkdir -p .claude/rules
  curl -o .claude/rules/coding-style.md https://raw.githubusercontent.com/eugeniosegala/claude-connoisseur/main/rules/coding-style.md
  ```

## What's included

### Rules

| Rule                                  | Description                                                                                                             |
|---------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| [coding-style](rules/coding-style.md) | Enforces consistent code style, modern syntax, meaningful comments, modularity, and test discipline across any language |

### Skills

#### Action skills

These skills modify code when invoked. User-triggered only — Claude will not run them automatically.

| Skill                                              | Command                    | Description                                                              |
|----------------------------------------------------|----------------------------|--------------------------------------------------------------------------|
| [functional](skills/functional/SKILL.md)           | `/functional <files>`      | Convert specified files to functional programming style                  |
| [object-oriented](skills/object-oriented/SKILL.md) | `/object-oriented <files>` | Convert specified files to object-oriented programming style             |
| [test-refactor](skills/test-refactor/SKILL.md)     | `/test-refactor <files>`   | Refactor tests for consistency, mocking patterns, isolation, and quality |
| [test-runner](skills/test-runner/SKILL.md)         | `/test-runner [files]`     | Run tests, fix failures, and re-run until the suite passes               |

#### Review skills

These skills are read-only — they analyse code and report findings without making changes.

| Skill                                        | Command                | Can Claude invoke | Description                                                                                                   |
|----------------------------------------------|------------------------|-------------------|---------------------------------------------------------------------------------------------------------------|
| [codex-review](skills/codex-review/SKILL.md) | `/codex-review`        | No                | Send plans, approaches, or code to OpenAI Codex CLI for an independent second opinion                         |
| [db-review](skills/db-review/SKILL.md)       | `/db-review <files>`   | Yes               | Review database schemas and suggest improvements for indexing, types, constraints, and more                   |
| [perf-review](skills/perf-review/SKILL.md)   | `/perf-review <files>` | Yes               | Review code for performance issues — algorithmic complexity, batching, caching, memory, concurrency, and more |
| [cost-review](skills/cost-review/SKILL.md)   | `/cost-review [files]` | No                | Estimate monthly cloud costs from infrastructure and app config, with optimisation suggestions                |

### Hooks

| Hook                                  | Trigger                 | Description                                                                                                                                                                        |
|---------------------------------------|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [auto-format](hooks/auto-format.sh)   | After `Write` or `Edit` | Auto-formats files using the appropriate formatter for the language — supports Python (ruff), JS/TS/CSS/HTML/JSON/YAML/Markdown (prettier), Terraform, Go, Rust, and Shell (shfmt) |
| [type-check](hooks/type-check.sh)     | After `Write` or `Edit` | Type-checks edited files — supports TypeScript (tsc), Python (mypy), Go (go vet), Rust (cargo check), and Java (javac). Silently skipped if no type checker is installed           |
| [commit-guard](hooks/commit-guard.sh) | Before `Bash`           | Intercepts git commit commands and blocks if staged files contain secrets (.env, API keys, tokens, private keys) or sensitive file patterns                                        |

### Skill examples

**`/functional`** — convert files to functional style:

```
/functional @service.ts @handler.ts
/functional utils.py, helpers.py
/functional @app.go and also convert the files it imports
/functional @processor.rb focus only on the data transformation methods
/functional @api.ts keep the existing class structure but make methods pure
```

**`/object-oriented`** — convert files to object-oriented style:

```
/object-oriented @service.ts @handler.ts
/object-oriented utils.py, helpers.py
/object-oriented @app.go and also convert the files it imports
/object-oriented @processor.rb focus only on the data transformation methods
/object-oriented @helpers.ts keep the existing function signatures as public methods
```

**`/test-refactor`** — refactor tests for consistency and quality:

```
/test-refactor @service.test.ts
/test-refactor tests/unit/
/test-refactor @handler.test.ts compare mocking patterns with tests/unit/auth.test.ts
/test-refactor @api.test.py focus on mocking consistency and test isolation
/test-refactor @service.test.ts and also check the source file for missing coverage
```

**`/test-runner`** — run tests and fix failures:

```
/test-runner
/test-runner @service.test.ts
/test-runner tests/unit/
/test-runner only the tests related to authentication
/test-runner fix the source code, not the tests
```

**`/codex-review`** — review plans, code, or both:

```
/codex-review review my current plan
/codex-review review the code I just wrote
/codex-review review the approach and the implementation together
```

**`/db-review`** — review database schemas:

```
/db-review @schema.sql
/db-review schema.prisma, migrations/001.sql
/db-review @models.py this is a write-heavy OLTP workload on PostgreSQL
/db-review @schema.sql focus on indexing and performance only
/db-review @schema.rb also check the migration files in db/migrations
```

**`/perf-review`** — review code for performance issues:

```
/perf-review @service.ts @handler.ts
/perf-review utils.py, helpers.py
/perf-review @app.go and also review the files it imports
/perf-review @api.ts focus only on database query performance
/perf-review @processor.rb we're seeing high memory usage in production
```

**`/cost-review`** — estimate monthly cloud costs:

```
/cost-review
/cost-review @main.tf @variables.tf
/cost-review assume 10k daily active users on AWS eu-west-1
/cost-review @serverless.yml we expect 1M invocations per month
/cost-review @docker-compose.yml this will run on ECS Fargate
```

## License

[MIT](LICENSE)
