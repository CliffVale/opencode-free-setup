# opencode-free-setup

**A complete, free AI coding setup for OpenCode — one command, any platform.**
Linux · macOS · Windows · Android/Termux

> Compiled and aligned from the best freely-available setups, models, MCP servers,
> skills, and workflow rules on the internet (full credits in [ATTRIBUTION.md](ATTRIBUTION.md)).
> No API keys required to start. No personal data inside.

```bash
# Linux / macOS / Termux
bash <(curl -fsSL https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main/install.sh)

# Windows (PowerShell)
irm https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main/install.ps1 | iex

# Zero-key alternative agent instead of OpenCode:
bash install.sh --agent=freebuff
```

## What you get

| Piece | What it is |
|---|---|
| **OpenCode** | open-source terminal AI agent (MIT) — or [Freebuff](docs/08-alternatives.md) with `--agent=freebuff` |
| **Free models, pre-configured** | Zen free lane as default (`deepseek-v4-flash-free`); 6 more lanes documented |
| **8 working MCPs** | keyless web research (Firecrawl), live library docs (Context7), filesystem, fetch, search, reasoning… |
| **94 curated skills** | brainstorming → TDD → debugging → code review · literature review → statistics → scientific writing · pdf/docx/xlsx/pptx |
| **Custom agents** | reviewer + deepsearch subagents on the free model |
| **Workflow rules** | plan→build loop, verification-before-completion, context hygiene — the habits that make agents actually good |

## Docs

1. [Install — Linux/macOS](docs/01-install-linux-macos.md)
2. [Install — Windows](docs/02-install-windows.md)
3. [Install — Termux/Android](docs/03-install-termux.md) *(the path that actually works)*
4. [Free models — all 7 lanes](docs/04-free-models.md)
5. [API keys guide](docs/05-api-keys-guide.md) *(all optional, all free-tier)*
6. [MCP reference](docs/06-mcps.md)
7. [Workflows](docs/07-workflows.md)
8. [Alternatives — Freebuff & friends](docs/08-alternatives.md)
9. [Troubleshooting](docs/09-troubleshooting.md)

## Cost

$0. The default model lane is free forever-rotating; every documented API is a free tier;
the two best web-research MCPs are now keyless. Optional: one-time $10 OpenRouter credit
turns 50 free requests/day into 1,000/day permanently.

## Privacy

Free-period models may train on prompts (stated per model). For sensitive code use the
local Ollama lane (docs/04). This repo contains no keys, no session history, no personal data —
enforced by CI ([scripts/sanitize-check.sh](scripts/sanitize-check.sh)).

## Science pack (private)

Domain-expert agents (COMSOL simulation, biosensor engineering, electrochemistry) live in a
separate **private** repo: `CliffVale/opencode-free-setup-science`. If you have access:
```bash
bash install.sh --with-science   # requires gh auth
```

## License

MIT for this repo's glue (installer, docs, config templates). Vendored skills keep their
original licenses — see ATTRIBUTION.md.
