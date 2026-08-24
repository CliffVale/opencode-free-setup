# Termux / Android install

OpenCode's official installer misdetects Termux (hands Android-arm64 a Linux-x64 binary —
upstream issue #21043). Use one of these working paths:

## Path 1 — opencode-termux npm wrapper ✅ recommended
```bash
pkg update && pkg upgrade
pkg install nodejs
npm install -g opencode-termux
opencode
```
Wraps the official ARM64 musl binary with the runtime Termux needs. Auto-installs deps,
verifies SHA-256 on download, auto-updates with upstream releases. Config lives in the
usual `~/.config/opencode`.

## Path 2 — guysoft/opencode-termux (native cross-compiled build)
```bash
curl -LO https://github.com/guysoft/opencode-termux/releases/latest/download/opencode-aarch64.pkg.tar.xz
pacman -U opencode-*-aarch64.pkg.tar.xz   # or the .deb variant
```
Caveat: community build lags upstream releases.

## Path 3 — proot-distro (current upstream version, heavier)
```bash
pkg install proot-distro
proot-distro install debian
proot-distro login debian
# inside: apt install curl nodejs npm && npm i -g opencode-ai
```

## After any path
```bash
opencode          # launch inside a project dir
/connect          # pick provider (Zen free models work from the phone)
```

## Android 12+ phantom process killer
Long agent sessions can die with `signal 9`. Mitigate:
```bash
settings put global settings_enable_monitor_phantom_procs false  # needs adb, device owner
# or run sessions under termux-services / tmux so they survive restarts
pkg install tmux  # tmux new -s ai
```

## Phone-friendly tips
- Pair Termux with Termux:Boot for autostart services.
- Keep models small-context tasks on the phone; heavy builds → SSH into a box.
