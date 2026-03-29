#!/usr/bin/env bash
# Pipe a prompt to codex exec in non-interactive mode.
# Usage: echo "prompt text" | ./run-codex.sh

if ! command -v codex &>/dev/null; then
  echo "Error: codex CLI is not installed. Install it with: npm install -g @openai/codex" >&2
  exit 1
fi

codex exec -
