#!/usr/bin/env bash
# opencode-free-setup installer — Linux / macOS / Termux
# Repo: https://github.com/CliffVale/opencode-free-setup
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main"
OPENCODE_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
WITH_SCIENCE=false
WITH_FREEBUFF=false
ASSUME_YES=false
SRC_ARG=""

for arg in "$@"; do
  case "$arg" in
    --with-science) WITH_SCIENCE=true ;;
    --agent=freebuff|--freebuff) WITH_FREEBUFF=true ;;
    -y|--yes) ASSUME_YES=true ;;
    --skip-tools) OCFS_SKIP_TOOLS=1 ;;   # config/skills only (CI / re-runs)
    --help|-h)
      sed -n '2,12p' "$0"; exit 0 ;;
    *) SRC_ARG="$arg" ;;
  esac
done

say()  { printf '\033[1;36m▸\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }
ask()  { $ASSUME_YES && return 0; read -rp "$1 [y/N] " a; [[ "${a,,}" == y ]]; }

# ── Detect platform ────────────────────────────────────────────────────
PLATFORM=linux
[[ "$(uname)" == Darwin ]] && PLATFORM=macos
if [[ -n "${TERMUX_VERSION:-}" || "${PREFIX:-}" == *com.termux* ]]; then PLATFORM=termux; fi
say "Platform: $PLATFORM ($(uname -m))"

# ── 1. Install OpenCode (or Freebuff) ─────────────────────────────────
have() { command -v "$1" &>/dev/null; }

if [[ "${OCFS_SKIP_TOOLS:-0}" == 1 ]]; then
  warn "OCFS_SKIP_TOOLS=1 — skipping tool installation (config/skills only)"
elif $WITH_FREEBUFF; then
  say "Installing Freebuff CLI (zero-key ad-funded agent)…"
  if [[ $PLATFORM == termux ]]; then pkg install -y nodejs; fi
  npm install -g freebuff && ok "Freebuff installed — run: freebuff"
else
  say "Installing OpenCode…"
  case $PLATFORM in
    termux)
      # Plain npm misdetects Termux arch (upstream issue #21043) → use the wrapper package
      have node || pkg install -y nodejs
      npm install -g opencode-termux && ok "OpenCode installed via opencode-termux"
      ;;
    macos)
      if have brew && ask "Install via Homebrew (recommended on macOS)?"; then
        brew install opencode
      else
        curl -fsSL https://opencode.ai/install | bash
      fi
      ok "OpenCode installed"
      ;;
    *)
      if have curl; then curl -fsSL https://opencode.ai/install | bash
      else warn "curl missing — install it, or use: npm i -g opencode-ai"; fi
      ok "OpenCode installed"
      ;;
  esac
fi

# ── 2. Base deps ──────────────────────────────────────────────────────
PKGS_MISSING=()
have git    || PKGS_MISSING+=(git)
have rg     || PKGS_MISSING+=(ripgrep)
if ((${#PKGS_MISSING[@]})); then
  say "Installing deps: ${PKGS_MISSING[*]}"
  if [[ $PLATFORM == termux ]]; then pkg install -y "${PKGS_MISSING[@]}"
  elif have apt-get; then sudo apt-get install -y "${PKGS_MISSING[@]}"
  elif have dnf; then sudo dnf install -y "${PKGS_MISSING[@]}"
  elif have pacman; then sudo pacman -S --needed --noconfirm "${PKGS_MISSING[@]}"
  elif have brew; then brew install "${PKGS_MISSING[@]}"
  else warn "Install manually: ${PKGS_MISSING[*]}"; fi
fi
have node || { say "Installing Node.js (needed for MCP servers)…"
  if [[ $PLATFORM == termux ]]; then pkg install -y nodejs
  elif have brew; then brew install node
  else warn "Install Node.js 18+ from https://nodejs.org"; fi; }

# ── 3. Config + skills ────────────────────────────────────────────────
mkdir -p "$OPENCODE_DIR/skills"
TMP=$(mktemp -d)
if [[ -n "$SRC_ARG" && -d "$SRC_ARG" ]]; then SRC="$SRC_ARG"   # local checkout for testing
else
  say "Fetching setup files from repo…"
  git clone --depth 1 https://github.com/CliffVale/opencode-free-setup "$TMP/repo"
  SRC="$TMP/repo"
fi

# config: never clobber without backup
if [[ -f "$OPENCODE_DIR/opencode.jsonc" || -f "$OPENCODE_DIR/opencode.json" ]]; then
  if ask "Existing OpenCode config found. Back it up and install template?"; then
    ts=$(date +%Y%m%d-%H%M%S)
    cp "$OPENCODE_DIR"/opencode.jsonc "$OPENCODE_DIR/opencode.jsonc.bak.$ts" 2>/dev/null || true
    cp "$SRC/setup/opencode.jsonc" "$OPENCODE_DIR/opencode.jsonc"
    ok "Config installed (backup: *.bak.$ts)"
  fi
else
  cp "$SRC/setup/opencode.jsonc" "$OPENCODE_DIR/opencode.jsonc"
  ok "Config installed"
fi

cp "$SRC/setup/AGENTS.md" "$OPENCODE_DIR/AGENTS.md" 2>/dev/null || true
mkdir -p "$OPENCODE_DIR/agents"
cp "$SRC/setup/agents/"*.md "$OPENCODE_DIR/agents/" 2>/dev/null || true

say "Installing skills (~40 core + research)…"
cp -r "$SRC/skills/." "$OPENCODE_DIR/skills/"
ok "Skills installed to $OPENCODE_DIR/skills"

# ── 4. Optional add-ons ───────────────────────────────────────────────
echo ""
say "Optional add-ons:"
ask "Add the PRIVATE science pack (comsol/biosensor/electrochemist agents)? Requires gh auth." \
  && WITH_SCIENCE=true
if $WITH_SCIENCE; then
  if have gh && gh auth status &>/dev/null; then
    gh repo clone CliffVale/opencode-free-setup-science "$TMP/science" 2>/dev/null \
      && cp -r "$TMP/science/skills/." "$OPENCODE_DIR/skills/" \
      && cp -r "$TMP/science/agents/." "$OPENCODE_DIR/agents/" 2>/dev/null || true
    ok "Science pack installed"
  else
    warn "gh not authed — later run: gh repo clone CliffVale/opencode-free-setup-science"
    warn "then copy its skills/ and agents/ into $OPENCODE_DIR/"
  fi
fi

if ask "Enable Telegram MCP (chat with your agent from your phone)? Needs a @BotFather token."; then
  python3 - "$OPENCODE_DIR/opencode.jsonc" <<'PY'
import sys
p=sys.argv[1]; s=open(p).read()
block='''    "tgcli": {
      "type": "local",
      "command": ["tgcli", "serve"],
      "enabled": true
    }
'''
s=s.replace('\n  },\n\n  // ── Extra agents','\n'+block+'  },\n\n  // ── Extra agents')
open(p,'w').write(s); print("tgcli added")
PY
fi

if ask "Enable Zotero MCP (reference manager)? Needs a Zotero API key."; then
  python3 - "$OPENCODE_DIR/opencode.jsonc" <<'PY'
import sys
p=sys.argv[1]; s=open(p).read()
block='''    "zotero": {
      "type": "local",
      "command": ["npx", "-y", "@oscardvs/zoteus"],
      "enabled": true,
      "environment": {"ZOTERO_API_KEY": "SET-ME", "ZOTERO_USER_ID": "SET-ME"}
    }
'''
s=s.replace('\n  },\n\n  // ── Extra agents','\n'+block+'  },\n\n  // ── Extra agents')
open(p,'w').write(s); print("zotero added")
PY
fi

rm -rf "$TMP"

# ── 5. Next steps ─────────────────────────────────────────────────────
cat <<EOF

$(printf '\033[1;32m')════════ Setup complete ════════$(printf '\033[0m')

Next steps:
  1. cd into any project and run:  opencode
  2. Type /connect → pick a provider (Zen = free models, no card)
  3. Type /models   → pick a free model (e.g. deepseek-v4-flash-free)

Want more free quota? See docs/05-api-keys-guide.md in the repo:
  Gemini ~1500 req/day · OpenRouter :free · Groq 14k req/day · Copilot 50/month

Privacy note: free-period Zen models may train on prompts.
For sensitive code, run Ollama locally instead (docs/04-free-models.md).
EOF
