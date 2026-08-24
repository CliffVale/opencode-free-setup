# The workflows this setup encodes

These are the house rules baked into AGENTS.md and the skill set — compiled from the best
open agent-workflow conventions (see ATTRIBUTION.md).

## 1. Plan → Build loop
- **Plan mode reads everything and can change nothing.** Describe the task there.
- Read the plan like a suspicious landlord reads a lease.
- Tab → build mode → approve step by step. `/undo` rolls back file changes in seconds.

## 2. Verification before completion
The agent may never claim "done" without running the verification command and reading its
output. Tests pass or it isn't done. This rule alone prevents most agent disasters.

## 3. Context hygiene
- `/compact` between tasks (keeps decisions, drops rambling).
- `/new` per task — fresh sessions don't inherit stale context.
- Delegate broad research to subagents (`@deepsearch`, `@reviewer`) — their mess stays
  on their whiteboard.
- `small_model` routes session titles/summaries to the cheap/free model.

## 4. Skills-first
Before any recognized task type (research, paper writing, statistics, plotting, debugging…),
the agent loads the matching SKILL.md. Browse what's installed:
```bash
ls ~/.config/opencode/skills
```
Key ones: brainstorming · writing-plans · test-driven-development · systematic-debugging ·
verification-before-completion · literature-review · scientific-writing · statistical-analysis.

## 5. Git discipline
Commit/push only when asked. Inspect status+diff first. Never commit secrets.

## 6. Project memory
Every project gets an `AGENTS.md` (`/init` drafts it) — structure, commands, conventions,
preferences. That's the agent's amnesia cure across sessions.

## Suggested reading order for new users
1. docs/04-free-models.md → pick your lane(s)
2. This file → adopt the plan/build habit
3. skills/ index → know what your agent can do
