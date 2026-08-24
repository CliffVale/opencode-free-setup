#!/usr/bin/env bash
# Sanitize guard — blocks personal data / secrets from entering the repo.
# Run locally before commit; runs automatically in CI.
set -uo pipefail
FAIL=0

check() { # pattern, label
  local hits
  hits=$(grep -rInE "$1" --exclude-dir=.git --exclude-dir=node_modules \
           --exclude=PLAN.md --exclude=sanitize-check.sh . 2>/dev/null | head -5)
  if [[ -n "$hits" ]]; then
    echo "❌ FOUND ($2):"; echo "$hits"; FAIL=1
  fi
}

# absolute home paths (allow doc placeholders /home/user, /home/yourname)
hits=$(grep -rInE '/home/[a-z0-9_.-]+' --exclude-dir=.git --exclude-dir=node_modules \
        --exclude=PLAN.md --exclude=sanitize-check.sh . 2>/dev/null \
      | grep -vE '/home/(user|yourname|<)|/data/data/com\.termux/files/home' | head -5)
[[ -n "$hits" ]] && { echo "❌ FOUND (absolute home path):"; echo "$hits"; FAIL=1; }

check '/run/media/'                        'mounted-drive path'
check '\bCliff\b|\bcliff\b'                'personal name (CliffVale repo handle is allowed)'
check '(?i)droidian|g965f|bhrigu'          'personal device references'
check '192\.168\.[0-9]{1,3}\.[0-9]{1,3}'   'LAN IP'
check '10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b' 'private 10.x IP'
check 'gho_[A-Za-z0-9]{20,}|github_pat_'   'GitHub token'
check 'sk-or-v1-[A-Za-z0-9]{20,}'          'OpenRouter key'
check 'sk-zen-[A-Za-z0-9]{20,}'            'Zen key'
check 'sk-ant-[A-Za-z0-9]{20,}'            'Anthropic key'
check 'fc-[a-f0-9]{20,}'                   'Firecrawl key'

# forbidden artifacts: credentials & chat/session history dumps
for f in $(find . -path ./.git -prune -o -type f \( -name "auth.json" -o -name "*.log" -o -name "*history*.md" \) -print 2>/dev/null); do
  echo "❌ FORBIDDEN FILE: $f"; FAIL=1
done

if ((FAIL)); then
  echo ""; echo "SANITIZE CHECK FAILED — fix the above, then re-run."; exit 1
fi
echo "✓ sanitize check passed"
