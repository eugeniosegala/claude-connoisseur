---
name: codex-review
description: Send plans, approaches, or code to OpenAI Codex CLI for independent review.
user_invocable: true
---

# Codex Review Skill

When invoked, send the relevant context — plans, approaches, code, or any combination — to `codex` CLI for an independent review.

## What can be reviewed

This skill covers **both** code and plans/approaches:

- **Plans/Approaches**: Architecture decisions, implementation strategies, proposed approaches before starting work
- **Code**: Code you've written, modified, or are considering changing — diffs, file contents, implementation details, proposed changes
- **Both together**: A plan alongside the code that implements it

Adapt what you send based on what the user asks Codex to review.

## How to use

1. **Gather context**: Collect the relevant material to send for review based on what the user asked:
   - **For plan/approach review**: Include the full plan text or approach description
   - **For code review**: Include the actual code or diff (`git diff`), what was changed, and why
   - **For both**: Include the plan AND the code/diff together
   - Always include enough project context for Codex to understand the domain

2. **Build the prompt**: Construct a clear prompt for Codex that includes:
   - The context of the project and what the user is trying to achieve
   - The code, plan, approach, or combination thereof
   - A request to review, identify potential issues, suggest improvements, and flag anything missing

3. **Run codex**: Use `codex exec` in non-interactive mode. For long prompts, pipe via stdin:

   ```bash
   cat <<'PROMPT' | codex exec -
   Review the following <code/plan/approach> for a software engineering task and provide feedback.

   ## Project Context
   <project context>

   ## What to Review
   <code, plan, approach, or combination>

   ## Please provide:
   1. Overall assessment
   2. Potential issues or risks
   3. Suggested improvements
   4. Anything missing or overlooked
   PROMPT
   ```

   Important:
   - Always use `codex exec` (non-interactive mode)
   - Prefer piping via stdin with heredoc for longer prompts
   - Set a reasonable timeout (use Bash timeout of 120000ms)

4. **Report back**: Present the Codex feedback to the user clearly:
   - Codex's overall assessment
   - Any concerns or suggestions raised
   - Your own response to the feedback (agree, disagree, or need to discuss)
