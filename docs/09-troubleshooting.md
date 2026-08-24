# Troubleshooting

## `opencode: incompatible binary` on Termux/Android
Official installer misdetects Termux (upstream issue #21043). Use the wrapper:
```bash
npm uninstall -g opencode-ai 2>/dev/null; npm i -g opencode-termux && opencode
```

## Android kills long sessions (`signal 9`)
Phantom process killer on Android 12+. Run inside `tmux`, disable via adb
(`settings put global settings_enable_monitor_phantom_procs false`), or use proot-distro.

## MCP tool errors: `invalid outputSchema … draft-07`
Strict clients reject draft-07 schemas from some servers (seen with agent-search-mcp).
Fix: pin-install + patch — see docs/06-mcps.md.

## `fetch` MCP fails: `uvx: command not found`
Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`. On Termux, just disable
the fetch MCP in opencode.jsonc (firecrawl covers it).

## No models after `/connect`
Run `/models` — free Zen models appear as `<name>-free`. If empty: check
`~/.local/share/opencode/auth.json` exists and wasn't created as root.

## Skills don't load
Skills must be at `~/.config/opencode/skills/<name>/SKILL.md` (exact casing). Symlinks
are fine. Restart OpenCode after adding skills.

## Config edits don't apply
Config loads at startup. Restart OpenCode. Validate your JSONC:
comments are allowed but trailing commas are not.

## Rate-limited mid-task
Stack lanes: switch model mid-session with `/models` (e.g., Zen → Gemini → OpenRouter :free).

## Reset everything
```bash
rm -rf ~/.config/opencode          # config+skills (back up first!)
rm -rf ~/.local/share/opencode     # auth + sessions
```
