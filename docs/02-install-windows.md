# Install — Windows

## Option A — native PowerShell (simplest)
```powershell
irm https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main/install.ps1 | iex
```
Installs OpenCode (native build) via winget/npm, copies config to
`%USERPROFILE%\.config\opencode`, installs skills + agents.

## Option B — WSL (recommended for heavy use)
Identical to Linux once inside WSL:
```powershell
wsl --install          # reboot, then open Ubuntu
```
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/CliffVale/opencode-free-setup/main/install.sh)
```
WSL gives you the full Linux toolchain (docker, systemd services, bash hooks) that some
skills assume.

## After install
```powershell
cd my-project
opencode
```
`/connect` → Zen free models → `/models` → pick one.

## Notes
- Native Windows build works for daily coding; prefer WSL if you hit a Unix-only skill.
- Node.js 18+ required for MCP servers (`winget install OpenJS.NodeJS.LTS`).
- Config location: `%USERPROFILE%\.config\opencode\opencode.jsonc`.
