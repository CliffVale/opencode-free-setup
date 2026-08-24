# Semantic Scholar API Module

> 学术论文元数据 / 引文网络专用策略 (Semantic Scholar API — free, keyless)

**触发场景**: 论文引用数、被引网络、期刊/会议过滤、DOI/标题批量解析、推荐论文、作者影响

## API 基础 (Free tier, no key required)
- **Base URL**: `https://api.semanticscholar.org/graph/v1`
- **Rate limit (anonymous)**: ~1,000 requests / 5 minutes shared pool. Be gentle — add retry with backoff.
- **Headers**: `Accept: application/json`. For bulk lookups set `X-API-KEY` if available (personal 1 RPS).
- **Best practice**: curl the API directly from bash for exact metadata. Prefer batch endpoints over single lookups.

## Endpoints (most useful)

### 1. Paper lookup by title (fuzzy match)
```bash
curl -s "https://api.semanticscholar.org/graph/v1/paper/search/match?query=<TITLE>&fields=title,year,authors,venue,citationCount,influentialCitationCount,externalIds,abstract,openAccessPdf,url"
```
- Returns the single best title match. Perfect for resolving a paper name → DOI / arXiv ID.

### 2. Paper search by keyword (with venue + year filtering)
```bash
curl -s "https://api.semanticscholar.org/graph/v1/paper/search?query=<KEYWORDS>&limit=20&fields=title,year,venue,citationCount,influentialCitationCount,externalIds,url&year=2020-2026&venue=<VENUE_OR_JOURNAL>&sort=citationCount:desc"
```
- `sort=citationCount:desc` → seminal/landmark papers first.
- `venue=` narrows to a journal/conference (e.g. "Nature", "NeurIPS").
- `year=START-END` or `year=2026-` for recency.

### 3. Citations / References (citation velocity — how a paper is being cited)
```bash
# Papers citing X (who builds on it)
curl -s "https://api.semanticscholar.org/graph/v1/paper/<ID>/citations?fields=title,year,venue,citationCount&limit=100"

# Papers X references (its foundations)
curl -s "https://api.semanticscholar.org/graph/v1/paper/<ID>/references?fields=title,year,venue,citationCount&limit=100"
```
- `<ID>` can be a DOI (`DOI:10.xxxx/yyyy`), arXiv ID (`ARXIV:2104.xxxxx`), S2 ID, CorpusID, or ACL ID.
- Citation velocity insight: many recent citations in a fast-moving field = actively built upon.

### 4. Batch lookup (up to 500 IDs)
```bash
curl -s "https://api.semanticscholar.org/graph/v1/paper/batch?fields=title,year,venue,citationCount,externalIds,abstract" \
  -H "Content-Type: application/json" \
  -d '{"ids":["DOI:10.1/abc","ARXIV:2104.12345","CorpusID:123456789"]}'
```

### 5. Recommendations (given a paper, what to read next)
```bash
curl -s "https://api.semanticscholar.org/graph/v1/recommendations/v1/papers/forpaper/<ID>?fields=title,year,venue,citationCount&limit=10"
```

### 6. Author lookup
```bash
curl -s "https://api.semanticscholar.org/graph/v1/author/search?query=<AUTHOR_NAME>&fields=name,affiliations,paperCount,citationCount,hIndex"
```

### 7. Dataset endpoint (bulk metadata, 500 IDs/req, 9,999 citations max) — for big analyses
`https://api.semanticscholar.org/datasets/v1/` (release snapshots, not real-time).

## 查询策略 (Academic enrichment)
- **Prefer batch over single** lookups when resolving multiple DOIs/titles.
- **Verify author, year, venue** from S2 against the actual PDF/DOI — S2 metadata can lag.
- **Citation count ≠ quality**: use `influentialCitationCount` and check WHO cites (recent? respected venues?).
- **Abstract via `openAccessPdf`**: when a paper is paywalled, check S2 for an OA PDF link; use `firecrawl`/`fetch` to grab it.
- **Known gaps**: S2 does NOT index all papers (biomedical coverage strong, some humanities weak). Cross-check with Google Scholar / Crossref when S2 returns nothing.
- **Combined with Zotero**: paste DOIs/titles into Zotero (via `zotero` MCP) for the local library; S2 gives the citation network ON TOP of what's in Zotero.
- **403/429 handling**: anonymous tier shares a pool — retry with exponential backoff (1s, 2s, 4s). A 403 usually means rate-limited, not unauthorized.
