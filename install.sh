#!/usr/bin/env bash
# RehamVim installer — multi-distro, robust, dependency-free.
# Supports: Arch/Manjaro (paru/yay/pacman), Debian/Ubuntu (apt), Fedora (dnf),
#           openSUSE (zypper), Void (xbps).

set -Eeuo pipefail

# ──────────────────────────── Colors & helpers ────────────────────────────

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

say()  { printf '%b\n' "${CYAN}[RehamVim]${RESET} $*"; }
ok()   { printf '%b\n' "${GREEN}[OK]${RESET} $*"; }
warn() { printf '%b\n' "${YELLOW}[WARN]${RESET} $*"; }
err()  { printf '%b\n' "${RED}[ERROR]${RESET} $*"; }

die() {
  err "$@"
  exit 1
}

REPO_URL="https://github.com/PzN2s/RehamVim.git"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# ────────────────────────────── Banner ────────────────────────────────────

printf '%b' "${BLUE}${BOLD}"
cat <<'EOF'
 ██████╗ ███████╗██╗  ██╗ █████╗ ███╗   ███╗
██╔══██╗██╔════╝██║  ██║██╔══██╗████╗ ████║
██████╔╝█████╗  ███████║███████║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██║██╔══██║██║╚██╔╝██║
██║  ██║███████╗██║  ██║██║  ██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
EOF
printf '%b\n' "${RESET}"
say "RehamVim installer — cross-distro."
echo

# ──────────────────────── Root / privilege detection ──────────────────────

SUDO=""
if [ "$(id -u)" -eq 0 ]; then
  say "Running as root."
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
  say "Using sudo for privileged operations."
elif command -v doas >/dev/null 2>&1; then
  SUDO="doas"
  say "Using doas for privileged operations."
else
  warn "No sudo or doas found — package installs may fail without root."
fi

# ───────────────────────────── Package manager ────────────────────────────

PM_INSTALL=""
PM_SEARCH=""

detect_pm() {
  case "$(uname -s)" in
    Linux) ;;
    *) die "Unsupported OS: $(uname -s). Only Linux is supported." ;;
  esac

  if command -v paru >/dev/null 2>&1; then
    PM_INSTALL="$SUDO paru -S --noconfirm --needed"
    PM_SEARCH="paru -Q"
    say "Package manager: paru (AUR)"
  elif command -v yay >/dev/null 2>&1; then
    PM_INSTALL="$SUDO yay -S --noconfirm --needed"
    PM_SEARCH="yay -Q"
    say "Package manager: yay (AUR)"
  elif command -v pacman >/dev/null 2>&1; then
    PM_INSTALL="$SUDO pacman -S --noconfirm --needed"
    PM_SEARCH="pacman -Q"
    say "Package manager: pacman (Arch)"
  elif command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update -y >/dev/null 2>&1 || true
    PM_INSTALL="$SUDO apt-get install -y"
    PM_SEARCH="dpkg -s"
    say "Package manager: apt (Debian/Ubuntu)"
  elif command -v dnf >/dev/null 2>&1; then
    PM_INSTALL="$SUDO dnf install -y"
    PM_SEARCH="rpm -q"
    say "Package manager: dnf (Fedora/RHEL)"
  elif command -v zypper >/dev/null 2>&1; then
    PM_INSTALL="$SUDO zypper --non-interactive install"
    PM_SEARCH="rpm -q"
    say "Package manager: zypper (openSUSE)"
  elif command -v xbps-install >/dev/null 2>&1; then
    PM_INSTALL="$SUDO xbps-install -y"
    PM_SEARCH="xbps-query"
    say "Package manager: xbps (Void)"
  else
    die "No supported package manager found. Install paru/yay/pacman, apt, dnf, zypper or xbps."
  fi
  echo
}

# ────────────────────────────── Install helper ────────────────────────────

install_pkgs() {
  local pkgs=("$@")
  if [ ${#pkgs[@]} -eq 0 ]; then
    return 0
  fi
  local pkgs_txt="${pkgs[*]}"
  say "Installing: $pkgs_txt"
  if ! $PM_INSTALL "${pkgs[@]}"; then
    warn "Automatic install failed for: $pkgs_txt"
    local retry
    while true; do
      read -r -p "  (r)etry, (s)kip, (e)xit? [r/s/e]: " -n 1 retry </dev/tty
      echo
      case "$retry" in
        r|R) if $PM_INSTALL "${pkgs[@]}"; then ok "$pkgs_txt installed"; return 0; else warn "Retry failed."; fi ;;
        s|S) warn "Skipping $pkgs_txt"; return 0 ;;
        e|E) die "Aborted by user." ;;
        *) echo "  Please answer r, s, or e." ;;
      esac
    done
  fi
  ok "$pkgs_txt installed"
}

# core deps by distro family
install_core_deps() {
  local pkgs=()
  for bin in git curl fzf ripgrep fd lazygit gh; do
    if ! command -v "$bin" >/dev/null 2>&1; then
      pkgs+=("$bin")
    fi
  done
  # normalise fd name (some distros ship 'fd-find' running as 'fdfind')
  if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
    case "$PM_SEARCH" in
      *paru*|*yay*|*pacman*) pkgs+=("fd") ;;
      *dpkg*)  pkgs+=("fd-find") ;;
      *rpm*)   pkgs+=("fd-find") ;;
      *xbps*)  pkgs+=("fd") ;;
    esac
  fi
  install_pkgs "${pkgs[@]}"
}

# neovim install (optional but recommended)
install_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    ok "Neovim already installed ($(nvim --version | head -1))"
    return 0
  fi
  if command -v nix >/dev/null 2>&1; then
    say "Nix found — recommending flake install instead."
    return 0
  fi
  install_pkgs "neovim"
  if ! command -v nvim >/dev/null 2>&1; then
    warn "Neovim binary not found after install — you may need to refresh your shell/restart."
  fi
}

# languages: resolves distro-correct package names
install_languages() {
  local to_install=()
  local pip_name="python3-pip"
  case "$PM_INSTALL" in
    *pacman*|*paru*) pip_name="python-pip" ;;
  esac
  for sel in "$@"; do
    case "$sel" in
      Go)        to_install+=("go") ;;
      Rust)      to_install+=("rustup") ;;
      Node.js)   to_install+=("nodejs" "npm") ;;
      Python)    to_install+=("python3" "$pip_name") ;;
    esac
  done
  install_pkgs "${to_install[@]}"
}

# ────────────────────────────────── Main ──────────────────────────────────

detect_pm

# 0. Core tools
install_core_deps

# 1. Neovim (recommended)
if [ -t 0 ]; then
  read -r -p "Install Neovim if missing? [Y/n]: " -n 1 do_nvim </dev/tty
  echo
  case "${do_nvim}" in
    n|N) warn "Skipping Neovim install." ;;
    *) install_neovim ;;
  esac
else
  install_neovim
fi

# 2. Languages (interactive)
if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
  languages=("Go:go" "Rust:rustup" "Node.js:nodejs" "Python:python3")
  say "Select languages to install (TAB/Space to select, Enter to continue, Esc to skip):"
  selected=$(printf '%s\n' "${languages[@]}" | fzf --multi --header "Languages for LSPs" \
    --color=fg:#d0d0d0,bg:#121212,hl:#5f87af \
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff \
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff \
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf || true)
  if [ -n "$selected" ]; then
    mapfile -t sel_names <<<"$selected"
    lang_pkgs=()
    for line in "${sel_names[@]}"; do
      lang_pkgs+=("${line%%:*}")
    done
    install_languages "${lang_pkgs[@]}"
  else
    warn "No languages selected — skipping."
  fi
else
  warn "fzf selection unavailable or non-interactive — skipping language install."
fi

# 3. Clone / update config
if [ -d "$CONFIG_DIR/.git" ]; then
  say "Existing RehamVim install found — updating."
  git -C "$CONFIG_DIR" pull --ff-only || warn "Could not auto-update; run 'git -C $CONFIG_DIR pull' later."
else
  if [ -d "$CONFIG_DIR" ]; then
    warn "Config directory exists but is not a git repo: $CONFIG_DIR"
    read -r -p "  (b)ackup, (o)verwrite, (c)ancel? [b/o/c]: " -n 1 reply </dev/tty
    echo
    case "$reply" in
      c|C) die "Cancelled." ;;
      b|B)
        backup="${CONFIG_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
        cp -r "$CONFIG_DIR" "$backup" && ok "Backup created: $backup" || die "Backup failed."
        rm -rf "$CONFIG_DIR" ;;
      o|O) rm -rf "$CONFIG_DIR" ;;
      *) die "Invalid option." ;;
    esac
  fi
  say "Cloning RehamVim into $CONFIG_DIR..."
  git clone "$REPO_URL" "$CONFIG_DIR" || die "Clone failed."
fi

echo
ok "RehamVim is ready! cd ~/ && nvim to start."
ok "On first run, Lazy installs all plugins automatically."
