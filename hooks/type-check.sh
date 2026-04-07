#!/usr/bin/env bash
# Type-check files after Claude Code writes or edits them.
# Detects the type checker by file extension and project config.
# Silently skips if the type checker is not installed or not configured.
#
# Supported languages:
#   TypeScript (.ts/tsx)   — tsc --noEmit (requires tsconfig.json)
#   Python (.py)           — mypy (requires mypy being installed)
#   Go (.go)               — go vet
#   Rust (.rs)             — cargo check (requires Cargo.toml)
#   Java (.java)           — javac via a temporary output directory

if [[ -t 0 ]]; then
  exit 0
fi

input=$(cat)

file_path=$(python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" <<< "$input" 2>/dev/null || true)

if [[ -z "$file_path" || ! -f "$file_path" ]]; then
  exit 0
fi

dir=$(dirname "$file_path")
ext="${file_path##*.}"

# Walk up to find a project root file
find_up() {
  local path="$dir"
  while [[ "$path" != "/" ]]; do
    if [[ -f "$path/$1" ]]; then
      echo "$path"
      return 0
    fi
    path=$(dirname "$path")
  done
  return 1
}

case "$ext" in
  ts|tsx)
    root=$(find_up "tsconfig.json") || exit 0
    command -v tsc &>/dev/null || exit 0
    cd "$root" && tsc --noEmit 2>&1
    ;;
  py)
    command -v mypy &>/dev/null || exit 0
    mypy "$file_path" 2>&1
    ;;
  go)
    command -v go &>/dev/null || exit 0
    go vet "$file_path" 2>&1
    ;;
  rs)
    root=$(find_up "Cargo.toml") || exit 0
    command -v cargo &>/dev/null || exit 0
    cd "$root" && cargo check --quiet 2>&1
    ;;
  java)
    command -v javac &>/dev/null || exit 0
    output_dir=$(mktemp -d "${TMPDIR:-/tmp}/type-check.XXXXXX")
    trap 'rm -rf "$output_dir"' EXIT
    javac -d "$output_dir" "$file_path" 2>&1
    ;;
esac

exit 0
