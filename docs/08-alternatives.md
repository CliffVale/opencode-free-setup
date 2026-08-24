# Alternatives — if you want a different shape of free

This repo sets up **OpenCode** (open source, BYOK, most configurable). The 2026 landscape
also offers:

## Freebuff — zero keys at all ⭐ the "no setup" option
`npm install -g freebuff`
- **No API key, ever.** Funded by text ads shown in the CLI.
- Models included: DeepSeek V4 Flash (default), GPT-5.6 Luna (2 sessions/day),
  MiMo 2.5 (unlimited), DeepSeek V4 Pro (1 session/day). GLM 5.2 via earned sessions.
- Five products: CLI · Desktop (parallel agents) · Web (prompt→deploy app) ·
  Cloud (agent on any GitHub repo) · Chat.
- Limited mode outside full-access countries / on VPN (MiMo only).
- ⚠️ Privacy trade: prompts may be analyzed for ad personalization; some data may train
  models. Fine for learning/public repos; not for proprietary code.
Our installer supports it: `install.sh --agent=freebuff`.

## Comparison table

| Tool | Free model bill | Shape | Best for |
|------|----------------|-------|----------|
| **OpenCode + this repo** | Zen/Gemini/OpenRouter free tiers | terminal agent, MCPs, skills | the full customizable setup |
| **Freebuff** | $0 (ads) | CLI + desktop + cloud | absolute beginners, no keys |
| **Aider** | you pay provider | terminal pair-programmer, git-native | minimalists who live in git |
| **Cline / Roo Code** | you pay provider | VS Code extension | editor-centric devs |
| **Continue + Ollama** | $0 local | IDE + local models | privacy-required environments |
| **Gemini CLI** | Gemini quota only | terminal | Google ecosystem users |

## Decision shortcuts
- "Just let me try AI coding NOW" → Freebuff
- "I want the power-user setup that grows with me" → OpenCode + this repo (you're here)
- "My code can't leave my machine" → Ollama lane (docs/04)
- "I live in VS Code" → Cline, or OpenCode in the integrated terminal
