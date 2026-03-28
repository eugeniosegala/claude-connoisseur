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

| Skill                                                  | Command               | Description                                                                           |
|--------------------------------------------------------|-----------------------|---------------------------------------------------------------------------------------|
| [codex-review](skills/codex-review/SKILL.md)           | `/codex-review`       | Send plans, approaches, or code to OpenAI Codex CLI for an independent second opinion |
| [functional](skills/functional/SKILL.md)               | `/functional <files>` | Convert specified files to functional programming style                               |
| [object](skills/object/SKILL.md)                       | `/object <files>`     | Convert specified files to object-oriented programming style                          |

### Hooks

| Hook                                       | Trigger                 | Description                                                                                                                                                                        |
|--------------------------------------------|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [auto-format](hooks/auto-format.sh)        | After `Write` or `Edit` | Auto-formats files using the appropriate formatter for the language — supports Python (ruff), JS/TS/CSS/HTML/JSON/YAML/Markdown (prettier), Terraform, Go, Rust, and Shell (shfmt) |

## Installation

Add the marketplace and install the plugin from within Claude Code:

```
/plugin marketplace add eugeniosegala/claude-connoisseur
/plugin install claude-connoisseur@eugeniosegala-claude-connoisseur
```

### Notes

- Skills will be namespaced as `/claude-connoisseur:codex-review`, `/claude-connoisseur:functional`, etc.
- The auto-format hook runs automatically after every `Write` or `Edit` — formatters are detected at runtime, so if a formatter isn't installed it is silently skipped.
- Rules are not distributed via the plugin system. To use the coding-style rule, copy it manually into your project:
  ```sh
  mkdir -p .claude/rules
  curl -o .claude/rules/coding-style.md https://raw.githubusercontent.com/eugeniosegala/claude-connoisseur/main/rules/coding-style.md
  ```

## License

[MIT](LICENSE)
