# Free models — the complete lane list

No single tutorial lists all free lanes together. This is that list (verified Aug 2026).
All work with OpenCode; most also work with Freebuff/Aider/Cline.

| # | Lane | What you get | Get it | Catch |
|---|------|--------------|--------|-------|
| 1 | **OpenCode Zen free models** | DeepSeek V4 Flash Free, Ox Alpha Free, MiMo-V2.5 Free, Hy3 Free, Nemotron 3 Ultra/Lightning Free, Big Pickle, Muse Spark 1.2 — all $0 | `/connect` → OpenCode → opencode.ai/auth | Roster rotates; some may train on prompts during free period |
| 2 | **GitHub Copilot allowance** | 50 premium requests/month | `/connect` → GitHub Copilot → github.com/login/device | Emergency flare, not a diet |
| 3 | **Google Gemini free tier** | ~1,500 Flash requests/day | aistudio.google.com (no card) | Per-minute rate limits |
| 4 | **OpenRouter `:free`** | 28+ models incl. Qwen3 Coder 480B (262K ctx); 50 req/day | openrouter.ai → Keys | One-time $10 credit ⇒ **1,000 req/day forever** |
| 5 | **Groq direct** | 30 RPM / 14,400 req/day, fastest tokens/sec on open models | console.groq.com | Open-weight models only |
| 6 | **Ollama local** | Unlimited, offline, private | ollama.com + config below | Smaller models; needs RAM |
| 7 | **freellmpool** | Pools 24 providers' free tiers behind one endpoint (+ MCP server) | `pip install freellmpool` | Extra moving part |

## Rotation warning
Free model lineups change monthly — yesterday's free flagship becomes paid the week a new
one lands free. Your setup survives; just run `/models` and pick the next one.

## Local (private) lane setup
```jsonc
{
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": { "baseURL": "http://localhost:11434/v1" },
      "models": { "qwen3-coder": { "name": "Qwen3 Coder" } }
    }
  }
}
```
If the local model ignores instructions, raise Ollama's context: `num_ctx` = 16384–32768
(the factory default is tiny).

## Privacy matrix
- Sensitive/proprietary code → **Ollama lane only**
- Hobby/public code → any lane; note Zen free-period models & Freebuff may train on prompts

## Alternative agent: zero keys at all
**Freebuff** (`npm i -g freebuff`) is ad-funded and needs no API key ever:
DeepSeek V4 Flash default, GPT-5.6 Luna (2 sessions/day), MiMo unlimited.
CLI/Desktop/Web/Cloud/Chat. Best for learning projects and public repos.
Our installer supports it: `install.sh --agent=freebuff`.
