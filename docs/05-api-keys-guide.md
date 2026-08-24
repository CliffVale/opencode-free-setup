# API keys guide — every optional key: where to get it, what it unlocks

**You need ZERO keys to start** (Zen free models + keyless Firecrawl/Context7 MCPs).
Each key below adds a lane. All are free-tier, no credit card unless noted.

| Key | Where to get | Card? | Unlocks | Worth it? |
|-----|--------------|-------|---------|-----------|
| **OpenCode Zen** | opencode.ai/auth → Create API Key | No | All Zen free models (default lane) | ✅ start here |
| **Google Gemini** | aistudio.google.com → Get API key | No | ~1,500 req/day volume lane | ✅ recommended |
| **OpenRouter** | openrouter.ai → Settings → Keys (`sk-or-…`) | No | 28+ `:free` models, 50 req/day | ✅ recommended |
| **Groq** | console.groq.com → API Keys | No | 30 RPM / 14,400 req/day speed lane | optional |
| **GitHub PAT** | github.com/settings/tokens (classic, `repo` scope) | No | github MCP (PRs/issues from chat) | optional |
| **Firecrawl** | firecrawl.dev | No | dashboard + higher limits (keyless already gives 1,000 credits/mo) | optional |
| **Exa** | exa.ai dashboard | No | neural search MCP, 1,000 req/month | optional |
| **Telegram Bot** | Telegram → @BotFather → /newbot | No | tgcli MCP: chat with your agent from your phone | optional |
| **Zotero** | zotero.org/settings/keys | No | zoteus MCP: your reference library in-chat | research users |

## How to plug a key into OpenCode
1. In the TUI: `/connect` → pick provider → paste key. Done.
2. Or edit `~/.config/opencode/opencode.jsonc` provider block directly.

## The famous $10 trick
OpenRouter free tier: 50 requests/day. Load **$10 of credit once** (not monthly — once)
and your free-model limit becomes **1,000 requests/day, permanently**. The only money in
this entire guide, and it's optional.

## Privacy notes
- Free-period Zen models: prompts may be used for training (stated openly per model).
- Freebuff: prompts/messages may be analyzed for ad personalization.
- Rule of thumb: hobby code anywhere, work code via Ollama or a paid zero-retention endpoint.

## Rate-limit math for planners
Gemini daily volume ≈ 1,500 · OpenRouter (post-$10) ≈ 1,000/day · Groq ≈ 14,400/day but
open models only · Copilot premium = 50/month. Stack lanes by task: planning on the smartest
free model, grunt work on the fastest.
