# What each MCP does — and whether it needs a key

Shipped enabled in the template:

| MCP | Type | Key? | What it gives the agent |
|-----|------|------|------------------------|
| **filesystem** | local npx | no | read/write/search files in allowed dirs |
| **fetch** | local uvx | no | fetch a URL as markdown (needs [uv](https://docs.astral.sh/uv/); auto-skipped on Termux) |
| **sequential-thinking** | local npx | no | structured multi-step reasoning tool |
| **firecrawl** | remote | **no** (keyless) | web search, scrape→markdown, crawl, PDF parse, monitoring — 1,000 credits/mo free |
| **context7** | remote | no | up-to-date library docs on demand |
| **agent-search** | local npx | optional | multi-engine search; DuckDuckGo/Sogou work with zero keys; Tavily/Brave/Exa keys raise quality |

Shipped disabled (flip `enabled: true` after adding keys):

| MCP | Key source | Purpose |
|-----|-----------|---------|
| **github** | github.com/settings/tokens | PRs/issues/repos from chat |
| **exa** | exa.ai | neural/semantic web search |

Installer-optional:
| tgcli | @BotFather token | chat with your agent via Telegram |
| zotero | zotero.org key + userID | your bibliography in-chat |

## agent-search zero-key note
Works out of the box with free engines. Known upstream quirk: its MCP SDK can emit a
draft-07 outputSchema that strict clients reject. If tools fail to load, pin + patch:
```bash
mkdir -p ~/.local/share/agent-search-mcp && cd ~/.local/share/agent-search-mcp
npm install agent-search-mcp
sed -i "s/draft-07/draft-2020-12/" node_modules/@modelcontextprotocol/sdk/dist/esm/server/zod-json-schema-compat.js
# then point the mcp command at: node ~/.local/share/agent-search-mcp/node_modules/agent-search-mcp/dist/index.js
```

## Adding your own
Any MCP server from the registry works — add a block under `"mcp"` in opencode.jsonc.
Prefer remote/keyless when available; keep GUI-dependent servers disabled by default.
