#!/usr/bin/env bash
# Auto-format files after Claude Code writes or edits them.
# Detects language by file extension and runs the appropriate formatter.
# Silently skips if the formatter is not installed.
#
# Supported languages:
#   Python (.py)                        — ruff format + ruff check --fix
#   JavaScript/TypeScript (.js/jsx/ts/tsx), CSS (.css/scss),
#     HTML (.html), JSON (.json), YAML (.yaml/yml), Markdown (.md)
#                                       — prettier
#   Terraform (.tf/tfvars)              — terraform fmt
#   Go (.go)                            — gofmt
#   Rust (.rs)                          — rustfmt
#   Shell (.sh/bash/zsh)                — shfmt

input=$(cat)

file_path=$(python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" <<< "$input" 2>/dev/null)

if [[ -z "$file_path" || ! -f "$file_path" ]]; then
  exit 0
fi

ext="${file_path##*.}"

case "$ext" in
  py)
    command -v ruff &>/dev/null && ruff format --quiet "$file_path" && ruff check --fix --quiet "$file_path"
    ;;
  js|jsx|ts|tsx|css|scss|html|json|yaml|yml|md)
    command -v prettier &>/dev/null && prettier --write --log-level=silent "$file_path"
    ;;
  tf|tfvars)
    command -v terraform &>/dev/null && terraform fmt "$file_path" >/dev/null
    ;;
  go)
    command -v gofmt &>/dev/null && gofmt -w "$file_path"
    ;;
  rs)
    command -v rustfmt &>/dev/null && rustfmt --quiet "$file_path"
    ;;
  sh|bash|zsh)
    command -v shfmt &>/dev/null && shfmt -w "$file_path"
    ;;
esac

exit 0
