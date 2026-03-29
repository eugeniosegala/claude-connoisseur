# Claude Connoisseur

<p align="center">
  <img src="assets/claude-connoisseur.png" alt="Claude Connoisseur" width="300" />
</p>

A collection of skills, rules, hooks and more for Claude Code, curated with taste for good coding!

## What's included

### Rules

| Rule                                        | Description                                                                                                             |
|---------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| [coding-style](rules/coding-style.md)       | Enforces consistent code style, modern syntax, meaningful comments, modularity, and test discipline across any language |

### Skills

| Skill                                                  | Command                   | User-triggered | Can Claude invoke | Description                                                                           |
|--------------------------------------------------------|---------------------------|----------------|-------------------|---------------------------------------------------------------------------------------|
| [codex-review](skills/codex-review/SKILL.md)           | `/ccn:codex-review`       | Yes            | No                | Send plans, approaches, or code to OpenAI Codex CLI for an independent second opinion |
| [functional](skills/functional/SKILL.md)               | `/ccn:functional <files>` | Yes            | No                | Convert specified files to functional programming style                               |
| [object](skills/object/SKILL.md)                       | `/ccn:object <files>`     | Yes            | No                | Convert specified files to object-oriented programming style                          |
| [db-review](skills/db-review/SKILL.md)                 | `/ccn:db-review <files>`  | Yes            | Yes               | Review database schemas and suggest improvements for indexing, types, constraints, and more |
| [perf-review](skills/perf-review/SKILL.md)             | `/ccn:perf-review <files>`| Yes            | Yes               | Review code for performance issues — algorithmic complexity, batching, caching, memory, concurrency, and more |

#### Examples

**`/ccn:codex-review`** — review plans, code, or both:
```
/ccn:codex-review review my current plan
/ccn:codex-review review the code I just wrote
/ccn:codex-review review the approach and the implementation together
```

**`/ccn:functional`** — convert files to functional style:
```
/ccn:functional @service.ts @handler.ts
/ccn:functional utils.py, helpers.py
/ccn:functional @app.go and also convert the files it imports
/ccn:functional @processor.rb focus only on the data transformation methods
/ccn:functional @api.ts keep the existing class structure but make methods pure
```

**`/ccn:object`** — convert files to object-oriented style:
```
/ccn:object @service.ts @handler.ts
/ccn:object utils.py, helpers.py
/ccn:object @app.go and also convert the files it imports
/ccn:object @processor.rb focus only on the data transformation methods
/ccn:object @helpers.ts keep the existing function signatures as public methods
```

**`/ccn:db-review`** — review database schemas:
```
/ccn:db-review @schema.sql
/ccn:db-review schema.prisma, migrations/001.sql
/ccn:db-review @models.py this is a write-heavy OLTP workload on PostgreSQL
/ccn:db-review @schema.sql focus on indexing and performance only
/ccn:db-review @schema.rb also check the migration files in db/migrations
```

**`/ccn:perf-review`** — review code for performance issues:
```
/ccn:perf-review @service.ts @handler.ts
/ccn:perf-review utils.py, helpers.py
/ccn:perf-review @app.go and also review the files it imports
/ccn:perf-review @api.ts focus only on database query performance
/ccn:perf-review @processor.rb we're seeing high memory usage in production
```

### Hooks

| Hook                                       | Trigger                 | Description                                                                                                                                                                        |
|--------------------------------------------|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [auto-format](hooks/auto-format.sh)        | After `Write` or `Edit` | Auto-formats files using the appropriate formatter for the language — supports Python (ruff), JS/TS/CSS/HTML/JSON/YAML/Markdown (prettier), Terraform, Go, Rust, and Shell (shfmt) |

## Installation

Add the marketplace and install the plugin from within Claude Code:

```
/plugin marketplace add eugeniosegala/claude-connoisseur
/plugin install ccn@eugeniosegala-claude-connoisseur
```

### Notes

- Skills will be namespaced as `/ccn:codex-review`, `/ccn:functional`, etc.
- The auto-format hook runs automatically after every `Write` or `Edit` — formatters are detected at runtime, so if a formatter isn't installed it is silently skipped.
- Rules are not distributed via the plugin system. To use the coding-style rule, copy it manually into your project:
  ```sh
  mkdir -p .claude/rules
  curl -o .claude/rules/coding-style.md https://raw.githubusercontent.com/eugeniosegala/claude-connoisseur/main/rules/coding-style.md
  ```

## License

[MIT](LICENSE)