# Install — Linux & macOS

## One-liner (everything: opencode + config + 94 skills + agents)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main/install.sh)
```

## Manual path
```bash
# 1. OpenCode
curl -fsSL https://opencode.ai/install | bash     # or: brew install opencode (mac)
#    deps
sudo apt install -y git ripgrep nodejs            # debian/ubuntu
sudo pacman -S --needed git ripgrep nodejs        # arch
brew install git ripgrep node                     # mac

# 2. Clone this repo and copy setup/
git clone https://github.com/CliffVale/opencode-free-setup
cp -r opencode-free-setup/setup/. ~/.config/opencode/
cp -r opencode-free-setup/skills/. ~/.config/opencode/skills/

# 3. Launch in a project
cd my-project && opencode
/connect   → OpenCode Zen (free models, no card)
/models    → deepseek-v4-flash-free (or whatever is free this month)
```

## First-session checklist
- [ ] `/connect` a provider (Zen = zero-card lane)
- [ ] `/models` pick a free model
- [ ] `/init` inside your project to draft its AGENTS.md
- [ ] Tab toggles plan/build mode — plan first, then build

## Optional science pack (private)
Requires GitHub access to `CliffVale/opencode-free-setup-science`:
```bash
gh auth login   # once
bash install.sh --with-science
```
