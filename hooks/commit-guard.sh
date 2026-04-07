#!/usr/bin/env bash
# Guard against committing secrets or sensitive files.
# Runs before Bash tool use — intercepts git commit commands and inspects
# the staged diff for common secret patterns.
#
# Blocks the commit if it finds:
#   - Staged files that should never be committed (.env, credentials, key files)
#   - Hardcoded secrets in the diff (API keys, tokens, passwords, private keys)
#
# Exit 2 = block the tool call. Exit 0 = allow it.

set -u

is_commit_command() {
  printf '%s\n' "$1" | grep -qE '\bgit\b.*\bcommit\b'
}

check_dangerous_files() {
  local dangerous_files

  dangerous_files=$(git diff --cached --name-only 2>/dev/null | grep -iE '\.env($|\.local|\.prod|\.secret)|credentials\.json|\.pem$|\.key$|id_rsa|id_ed25519|\.keystore$|secret\.ya?ml$|\.tfvars$' || true)

  if [[ -n "$dangerous_files" ]]; then
    echo "BLOCKED: potentially sensitive files are staged for commit:"
    echo ""
    printf '%s\n' "$dangerous_files"
    echo ""
    echo "Unstage them with: git reset HEAD <file>"
    exit 2
  fi
}

check_staged_diff() {
  local staged_diff
  local secrets_found

  staged_diff=$(git diff --cached 2>/dev/null || true)

  if [[ -z "$staged_diff" ]]; then
    exit 0
  fi

  # Only inspect added lines for patterns that strongly suggest hardcoded secrets.
  secrets_found=$(printf '%s\n' "$staged_diff" | grep '^+' | grep -v '^+++' | grep -iE \
    'AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|glpat-[a-zA-Z0-9_-]{20}|xox[bpsar]-[a-zA-Z0-9-]+|-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----|password\s*[:=]\s*["\x27][^"\x27]{8,}|secret\s*[:=]\s*["\x27][^"\x27]{8,}' \
    || true)

  if [[ -n "$secrets_found" ]]; then
    echo "BLOCKED: possible secrets detected in staged changes:"
    echo ""
    printf '%s\n' "$secrets_found" | head -10
    echo ""
    echo "Review the diff and remove secrets before committing."
    exit 2
  fi
}

manual_mode=0
input=""
command_str=""

if [[ -t 0 ]]; then
  manual_mode=1
else
  input=$(cat)

  if [[ -z "$input" ]]; then
    manual_mode=1
  else
    command_str=$(python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" <<< "$input" 2>/dev/null || true)
  fi
fi

if [[ "$manual_mode" -eq 0 ]] && ! is_commit_command "$command_str"; then
  exit 0
fi

check_dangerous_files
check_staged_diff

exit 0
