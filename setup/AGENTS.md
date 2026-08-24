# Global rules for OpenCode

Curated from the best open agent-rule conventions (superpowers, OpenCode community,
AGENTS.md standard) — see ATTRIBUTION.md in the opencode-free-setup repo.

## CodeGraph
In repositories indexed by CodeGraph (`.codegraph/` at repo root), reach for it BEFORE
grep/find when you need to understand or locate code. Shell fallback: `codegraph explore "<query>"`.
No index → skip; indexing is the user's decision.

## Verification before completion
Never claim work is done without running the verification command and reading its output.
Evidence before assertions — always.

## Plan → Build loop
- Use **plan mode** to read, explore, and design. It cannot edit files.
- Switch to build mode (Tab) only after the plan is reviewed.
- `/undo` rolls back file changes; use it without shame.

## Context hygiene
- `/compact` between tasks; `/new` per task.
- Subagents keep their research mess out of your context — delegate broad searches.
- Set `small_model` so internal chores never burn main-model quota.

## Git discipline
- Only commit/push/create PRs when explicitly asked.
- Inspect `git status` + `git diff` before committing; stage only intended files; never commit secrets.

## Memory & TODOs
- Project memory: prefer an `AGENTS.md` per project (`/init` drafts it).
- When the user says "save for later" → add to their todo store; "done" → mark complete.

## Skills
Load the matching skill before starting any task that names one (research, paper writing,
statistics, plotting...). Skills live in `~/.config/opencode/skills/<name>/SKILL.md`.
