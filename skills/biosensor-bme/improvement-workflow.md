# biosensor-bme — Continuous Improvement Workflow

This document defines how the biosensor-bme agent stays current and improves over time. The agent has an explicit mandate from the user to **keep updating itself from fresh/credible internet sources and from feedback**.

## 1. Feedback Ingestion (after every session)

- After each session, if the user corrected a fact, revealed a new technique, or changed project direction, save an agentmemory lesson:
  ```
  agentmemory_memory_lesson_save(
    content: "<what was learned>",
    project: "biosensor-bme",
    tags: "biosensor-bme,biosensing,<topic>",
    confidence: 0.7
  )
  ```
- Review recent lessons before starting a new task on the same topic (`memory_lesson_recall query:"biosensor"`).
- Every ~10 sessions, consolidate repeated lessons into the SKILL.md if a durable pattern emerged.

## 2. Fresh Literature Loop (web refresh)

The user explicitly wants the agent updated from credible internet sources. On **every task**, and at minimum **monthly**, run targeted web searches with current-year qualifiers:

| Topic | Search hints |
|-------|--------------|
| Wearable sweat sensors | `sweat biosensor 2026 review wearable` |
| Aptamer electrochemical sensors | `electrochemical aptamer sensor continuous monitoring 2025 2026` |
| Microneedle / ISF | `microneedle biosensor interstitial fluid 2026` |
| Commercial launches | `<company> wearable sensor news 2026` |
| Instrumentation | `potentiostat release 2026`, `open-source potentiostat` |
| CRP-specific | `CRP aptamer sweat wearable 2026`, `sweat CRP correlation serum` |

**Credible sources:** peer-reviewed journals (Biosensors & Bioelectronics, ACS Sensors, Analytical Chemistry, Nature Biomedical Engineering, Science Advances, Lab on a Chip, Advanced Materials), PubMed/PMC, RSC/IOP/Springer/Elsevier, official company sites, FDA announcements. **Do not** cite random blogs or unverified social media.

**Update rule:** when new info is material (a benchmark device, a new commercial product, a changed method), update the relevant SKILL.md section and note the update date.

## 3. Trigger Evaluation (skill health check)

The skill's trigger quality matters — the agent must activate when the user mentions biosensing.

- **eval_set.json** holds 25 queries (20 positive / 5 negative).
- Re-run regularly:
  ```bash
  # via opencode-skill-creator plugin or manually:
  opencode run --agent biosensor-bme --prompt "<sample trigger>" --title "oc-temp-trigger-check"
  ```
- If positive triggers stop activating or negatives start activating, fix the `description` in SKILL.md frontmatter (description is what drives skill selection) and the `triggers` list in agent.json.
- **Schedule:** monthly, or after any major change to the domain.

## 4. Scheduled Re-Training Cadence

- **Monthly:** literature refresh + eval_set re-run + SKILL.md update if warranted.
- **Quarterly:** review saved lessons; prune stale facts (e.g., outdated product status); update the commercial landscape section; re-verify vendor/model specs.
- **On project phase change:** when the user's CRP project moves Phase 1 → 2 → 3 → 4 (biophysical → electrochemical → wearable integration → clinical), pre-emptively refresh the knowledge relevant to the next phase (e.g., enter clinical phase → pull regulatory + sweat↔blood correlation literature).

## 5. How to Add New Tools/MCPs

If new capabilities become available (e.g., a literature MCP, a COMSOL bridge, a Python env for data analysis):
1. Add a row in the SKILL.md "Tool Usage" table.
2. If the agent should use it by default, mention it in the agent prompt / workflow.
3. Log in agentmemory and update this file's tool section.

## 6. Version Tracking

- Bump `metadata.version` in SKILL.md on substantive updates (minor +0.0.1 for fixes, +0.1 for new sections, +1.0 for major rewrites).
- Keep a changelog at the bottom of this file.

---

## Changelog

- **v1.0.0** (2026-08-01): Initial creation via deepsearch-research workflow. Seeded with the user's CRP pseudoknot aptamer project (memory + ~/Documents/Opencode_docking_pipeline/), 2024–2026 wearable biosensing literature, electrochemistry/SAM knowledge, and instrumentation landscape. 40 test prompts, 25 eval queries.
