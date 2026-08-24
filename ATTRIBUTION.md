# Attribution & provenance

This repository is a **curated compilation**: it selects, aligns, and packages work that
was already freely available on the internet into one reproducible setup. Nothing here
claims originality except the curation, sanitization, installer glue, and docs.

## Curated sources

| Source | What we took | License |
|--------|--------------|---------|
| [OpenCode](https://github.com/anomalyco/opencode) | the agent itself; config schema conventions | MIT / sspl-variant (upstream) |
| [obra/superpowers](https://github.com/obra/superpowers) | workflow skills: brainstorming, writing/executing plans, TDD, systematic debugging, code review, git worktrees, parallel agents | see upstream |
| [Firecrawl skills](https://github.com/firecrawl) (~30 skill dirs) | firecrawl-* suite (scrape/search/crawl/monitor/research…) | MIT |
| [anthropics/skills](https://github.com/anthropics/skills) lineage | docx, pptx, xlsx, pdf document skills | upstream license |
| [claude-scientific-skills](https://github.com/kieranklaassen/claude-scientific-skills) (community curations) | scientific/statistical skills (matplotlib, seaborn, scikit-learn, statsmodels, sympy, networkx, polars, shap, biopython, neurokit2, pathway-enrichment, uncertainty-and-units…) | MIT |
| Community skill authors | caveman suite, ponytail suite, cavecrew, i-have-adhd, markdown-mermaid-writing, deep-research, ai-engineer, opencode-maintainer, termux, playwright-skill, shadcn, web-dev, literature-review, citation-management, peer-review, scientific-* suite, research-grants, pyzotero… | per-skill headers |
| [lennney/agent-search-mcp](https://github.com/lennney/agent-search-mcp) | multi-engine search MCP (+ our draft-2020-12 patch note) | MIT |
| [@modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) | filesystem, fetch, sequential-thinking, github MCPs | MIT |
| [Firecrawl Keyless](https://www.firecrawl.dev/blog/firecrawl-keyless-launch) | keyless remote MCP endpoint (1,000 credits/mo) | service ToS |
| [Context7](https://context7.com) (Upstash) | keyless remote docs MCP | service ToS |
| [exa-mcp-server](https://github.com/exa-labs/exa-mcp-server) | optional neural search MCP | MIT |
| Free model lanes knowledge | opencode.ai/zen docs · Towards AI "OpenCode for free 2026" · freellms.org directory · freellmpool | referenced, not vendored |
| [CodebuffAI/freebuff](https://github.com/CodebuffAI/freebuff) | zero-key alternative agent (documented; not bundled) | MIT |
| Termux install paths | guysoft/opencode-termux · npm opencode-termux · retired64/opencode-termux | MIT / per-repo |

## Sanitization statement
- No API keys, tokens, or credentials are included (CI-enforced).
- No personal names, hosts, IPs, domains, or session history are included (CI-enforced).
- Skills were de-personalized where they contained machine-specific paths or device names.

## Removal / correction
If you are an author of any vendored skill and want it removed or credited differently,
open an issue — removals are honored promptly.
