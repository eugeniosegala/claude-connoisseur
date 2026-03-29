---
name: codex-review
description: Send plans, code, or approaches to OpenAI Codex CLI for independent review.
argument-hint: "[context]"
user-invocable: true
disable-model-invocation: true
context: fork
allowed-tools: Read, Grep, Glob, Bash
---

# Codex Review

When invoked, send the relevant context — plans, approaches, code, or any combination — to `codex` CLI for an independent review.

Files and instructions: $ARGUMENTS

## What to review

This skill covers **both** code and plans/approaches:

- **Plans/Approaches**: Architecture decisions, implementation strategies, proposed approaches before starting work
- **Code**: Code you've written, modified, or are considering changing — diffs, file contents, implementation details, proposed changes
- **Both together**: A plan alongside the code that implements it

Adapt what you send based on what the user asks Codex to review.

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- Natural language describing what to review: "review my current plan", "review the last commit"
- File references alongside instructions: `@auth.ts review this file for security issues`
- Scope instructions: "review the approach and the implementation together"

Parse the arguments to determine what context to gather and send to Codex.

### Examples

- `/codex-review review my current plan` — review the plan from the current conversation
- `/codex-review review the code I just wrote` — review recent code changes
- `/codex-review review the approach and the implementation together` — review both plan and code
- `/codex-review @auth.ts review this file for security issues` — review a specific file with focus
- `/codex-review review the last commit` — review the most recent commit diff

## How to proceed

1. **Gather context**: Collect the relevant material to send for review based on what the user asked:
   - **For plan/approach review**: Include the full plan text or approach description
   - **For code review**: Include the actual code or diff (`git diff`), what was changed, and why
   - **For both**: Include the plan AND the code/diff together
   - Always include enough project context for Codex to understand the domain

2. **Build the prompt**: Construct a clear prompt for Codex that includes:
   - The context of the project and what the user is trying to achieve
   - The code, plan, approach, or combination thereof
   - A request to review, identify potential issues, suggest improvements, and flag anything missing

3. **Run codex**: Write the full prompt to a temporary file, then pipe it to the helper script:

   ```bash
   echo "Review the following <code/plan/approach> for a software engineering task and provide feedback.

   ## Project Context
   <project context>

   ## What to Review
   <code, plan, approach, or combination>

   ## Please provide:
   1. Overall assessment
   2. Potential issues or risks
   3. Suggested improvements
   4. Anything missing or overlooked" | skills/codex-review/run-codex.sh
   ```

   Important:
   - Always use `echo "..." | skills/codex-review/run-codex.sh` — never use heredocs (indentation causes hangs)
   - The script checks that `codex` is installed and exits with a clear error if not
   - Set a reasonable timeout (use Bash timeout of 300000ms)

4. **Report back**: Present the Codex feedback to the user clearly:
   - Codex's overall assessment
   - Any concerns or suggestions raised
   - Your own response to the feedback (agree, disagree, or need to discuss)
