# Scholarly Open APIs Module (keyless)

> 免费学术 API 集合 — OpenAlex / Unpaywall / Crossref / arXiv / Europe PMC / DataCite /
> Zenodo / Wikidata SPARQL / Papers with Code / PubChem. All free, no API key required.

**触发场景**: 论文元数据全覆盖、DOI 解析、开放获取 PDF 查找、数据集/软件查找、实体消歧、化学结构

Use `curl` directly from bash. All endpoints are keyless (rate-limited but generous).
Prefer OpenAlex for metadata coverage, Semantic Scholar for citation networks (see
`semantic-scholar.md`), Unpaywall for legal OA PDFs.

---

## 1. OpenAlex — BEST free metadata coverage (250M+ works)

`https://api.openalex.org/` — no key. One call covers works, authors, venues, concepts.

```bash
# Search works by title/keywords
curl -s "https://api.openalex.org/works?search=biosensor%20graphene&per-page=10"

# Exact DOI resolution
curl -s "https://api.openalex.org/works/doi:10.1038/nature14539"

# Filter by year + venue (journal) + sort by citations
curl -s "https://api.openalex.org/works?search=CRISPR&filter=from_publication_date:2023-01-01,primary_location.source.display_name:Nature&sort=cited_by_count:desc&per-page=20"

# Author profile
curl -s "https://api.openalex.org/authors?search=Jane%20Doe"
```

Fields of interest in responses: `display_name`, `publication_year`, `cited_by_count`,
`primary_location.source.display_name` (venue), `doi`, `open_access.oa_url` (OA PDF),
`authorships[].author.display_name`.

Key filters: `from_publication_date:YYYY-MM-DD`, `primary_location.source.display_name:`,
`authorships.author.id:`. Sort: `cited_by_count:desc`, `publication_date:desc`.
Pagination: `page=1&per-page=100` (max 200/page; `cursor=` for >10k results).

## 2. Unpaywall — legal OA PDF finder (THE companion to PDF ingestion)

`https://api.unpaywall.org/v2/<DOI>?email=YOUR_EMAIL` — no key, just an email param.

```bash
curl -s "https://api.unpaywall.org/v2/10.1038/nature14539?email=you@example.com"
```

Response `best_oa_location.url_for_pdf` gives a legal OA PDF URL. Combine with the
ai-engineer PDF helper: S2 `openAccessPdf` → **Unpaywall fallback** → download →
`pdf-to-markdown.py`.

## 3. Crossref — DOI / funder / license metadata backbone

`https://api.crossref.org/` — no key. The authoritative DOI registry.

```bash
# Metadata for one DOI
curl -s "https://api.crossref.org/works/10.1038/nature14539"

# Search works by query + filter by funder
curl -s "https://api.crossref.org/works?query=biosensor&filter=has-funder:true&rows=10"

# Journal info (ISSN lookup → journal name)
curl -s "https://api.crossref.org/journals/0028-0836"
```

## 4. arXiv API — preprints (Atom XML)

`http://export.arxiv.org/api/query` — no key.

```bash
# Search by terms, sorted by relevance, get 20
curl -s "http://export.arxiv.org/api/query?search_query=all:transformer+AND+cat:cs.CL&start=0&max_results=20"
```

Parse the Atom XML (entries: title, summary, authors, published, id = arXiv number).

## 5. Europe PMC REST — biomedical full-text search

`https://www.ebi.ac.uk/europepmc/webservices/rest/` — no key. Strong for bio/med.

```bash
# Search articles, JSON
curl -s "https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=biosensor&format=json&pageSize=20"

# Get full text XML for a PMCID
curl -s "https://www.ebi.ac.uk/europepmc/webservices/rest/PMC123456/fullTextXML"
```

## 6. DataCite — find the *dataset/software* behind a paper

`https://api.datacite.org/` — no key. DOI registry for data/software (not papers).

```bash
curl -s "https://api.datacite.org/dois?query=biosensor&page[size]=10"
```

## 7. Zenodo REST — EU data repository

`https://zenodo.org/api/` — no key for read/search.

```bash
curl -s "https://zenodo.org/api/records?q=biosensor&size=10"
```

## 8. Wikidata SPARQL — entity disambiguation (chemicals, organisms, people)

`https://query.wikidata.org/sparql?query=...&format=json` — no key.

```bash
# Find the QID for a chemical
curl -sG "https://query.wikidata.org/sparql" \
  --data-urlencode 'query=SELECT ?item ?itemLabel WHERE { ?item wdt:P31 wd:Q11173; rdfs:label ?itemLabel. FILTER(CONTAINS(LCASE(?itemLabel), "glucose")). } LIMIT 5' \
  --data-urlencode 'format=json'
```

Use QIDs to cross-link entities across sources (PubChem CID ↔ Wikidata ↔ ChEBI).

## 9. Papers with Code — papers → code → benchmark leaderboards

`https://paperswithcode.com/api/v1/` — no key.

```bash
# Papers matching a task (e.g. image classification)
curl -s "https://paperswithcode.com/api/v1/papers/?q=biosensor"
# Task leaderboards
curl -s "https://paperswithcode.com/api/v1/tasks/"
```

## 10. PubChem REST — chemical/compound data (biosensor-relevant)

`https://pubchem.ncbi.nlm.nih.gov/rest/pug/` — no key.

```bash
# Compound CID by name
curl -s "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/glucose/cids/JSON"
# Full compound record
curl -s "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/5793/property/MolecularFormula,MolecularWeight/JSON"
# Similar compounds by SMILES
curl -s "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/<SMILES>/cids/JSON?MaxRecords=10"
```

---

## 查询策略 (Which API when)

| Need | Use |
|------|-----|
| Paper metadata (broad coverage) | **OpenAlex** first |
| Citation network / who-cites-whom | **Semantic Scholar** (semantic-scholar.md) |
| Legal OA PDF for a DOI | **Unpaywall** |
| DOI registration facts (funder, license) | **Crossref** |
| Preprints (fast, physics/CS/ML) | **arXiv** |
| Biomedical full-text | **Europe PMC** |
| Underlying dataset/software | **DataCite / Zenodo** |
| Entity disambiguation (chemical/organism) | **Wikidata SPARQL** (+ PubChem for compounds) |
| Paper ↔ code ↔ benchmark | **Papers with Code** |
| Compound properties | **PubChem** |

Rate-limit etiquette: these are shared free tiers. Add `sleep 1` between calls in
loops; use `per-page`/`page` pagination instead of scraping. If a 429/403 appears,
retry with exponential backoff (1s, 2s, 4s) — it's rate-limiting, not auth.

Cross-check rule (ai-engineer discipline): never report a paper's metadata from a
single API — confirm DOI/title/venue against a second source (e.g. OpenAlex + Crossref).
