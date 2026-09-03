#!/usr/bin/env bash
# RehamVim installer — multi-distro, robust, dependency-free.
# Supports: Arch/Manjaro (paru/yay/pacman), Debian/Ubuntu (apt), Fedora (dnf),
#           openSUSE (zypper), Void (xbps).
#
# Usage: install.sh [--doctor] [--dry-run] [--unattended]

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

# ────────────────────────────── Mode flags ────────────────────────────────

DOCTOR=0
DRY_RUN=0
UNATTENDED=0

for arg in "$@"; do
  case "$arg" in
    --doctor)     DOCTOR=1 ;;
    --dry-run)    DRY_RUN=1 ;;
    --unattended) UNATTENDED=1 ;;
    -h|--help)
      cat <<'EOF'
RehamVim Installer

Usage: install.sh [OPTIONS]

Options:
  --doctor       Check system only (no install), report missing/outdated tools
  --dry-run      Show what would be installed and commands that would run
  --unattended   Non-interactive, auto-yes to all prompts (CI friendly)
  -h, --help     Show this help

Environment:
  REHAMVIM_REPO  Override repo URL (default: https://github.com/PzN2s/RehamVim.git)
EOF
      exit 0
      ;;
    *) die "Unknown option: $arg. Use --help for usage." ;;
  esac
done

# Dry-run wrapper
run() {
  if [ $DRY_RUN -eq 1 ]; then
    say "[DRY-RUN] $*"
    return 0
  fi
  "$@"
}

# Confirm before executing any install/download command.
# Skipped entirely in --unattended, --doctor, and --dry-run (auto-proceed).
confirm_cmd() {
  if [ $UNATTENDED -eq 1 ] || [ $DOCTOR -eq 1 ] || [ $DRY_RUN -eq 1 ] || [ ! -t 0 ]; then
    return 0
  fi
  local ans
  read -r -p "  Run: $* — proceed? [Y/n]: " -n 1 ans </dev/tty
  echo
  case "${ans}" in
    n|N) warn "Skipped by user: $*"; return 1 ;;
    *)   return 0 ;;
  esac
}

REPO_URL="${REHAMVIM_REPO:-https://github.com/PzN2s/RehamVim.git}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# Summary arrays
INSTALLED=()
SKIPPED=()
FAILED=()

record_installed() { INSTALLED+=("$1"); }
record_skipped()   { SKIPPED+=("$1"); }
record_failed()    { FAILED+=("$1"); }

# ────────────────────────────── Banner ────────────────────────────────────

printf '%b' "${BLUE}${BOLD}"
cat <<'EOF'
 ██████╗ ███████╗██╗  ██╗ █████╗ ███╗   ███╗
██╔══██╗██╔════╝██║  ██║██╔══██╗████╗ ████║
██████╔╝█████╗  ███████║███████║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██║██╔══██║██║╚██═╝██║
██║  ██║███████╗██║  ██║██║  ██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
EOF
printf '%b\n' "${RESET}"

if [ $DOCTOR -eq 1 ]; then
  say "Doctor mode — system health check only."
elif [ $DRY_RUN -eq 1 ]; then
  say "Dry-run mode — showing commands without executing."
else
  say "RehamVim installer — cross-distro."
fi
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
    if [ $UNATTENDED -eq 1 ] || [ $DOCTOR -eq 1 ] || [ $DRY_RUN -eq 1 ] || [ ! -t 0 ]; then
      run $SUDO apt-get update -y >/dev/null 2>&1 || true
    elif confirm_cmd $SUDO apt-get update; then
      run $SUDO apt-get update -y >/dev/null 2>&1 || true
    fi
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
    if [ $DOCTOR -eq 1 ]; then
      warn "No supported package manager found — package checks disabled."
      PM_INSTALL=""
      PM_SEARCH=""
      return 0
    fi
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
  if ! confirm_cmd $PM_INSTALL "${pkgs[@]}"; then
    warn "Skipping $pkgs_txt"
    for p in "${pkgs[@]}"; do record_skipped "$p"; done
    return 0
  fi
  if run $PM_INSTALL "${pkgs[@]}"; then
    ok "$pkgs_txt installed"
    for p in "${pkgs[@]}"; do record_installed "$p"; done
    return 0
  fi
  warn "Automatic installation failed for: $pkgs_txt"
  for p in "${pkgs[@]}"; do record_failed "$p"; done

  if [ $UNATTENDED -eq 1 ] || [ $DOCTOR -eq 1 ] || [ $DRY_RUN -eq 1 ]; then
    return 1
  fi

  local retry
  while true; do
    read -r -p "  (r)etry, (s)kip, (e)xit? [r/s/e]: " -n 1 retry </dev/tty
    echo
    case "$retry" in
      r|R)
        if confirm_cmd $PM_INSTALL "${pkgs[@]}"; then
          if run $PM_INSTALL "${pkgs[@]}"; then
            ok "$pkgs_txt installed (retry)"
            for p in "${pkgs[@]}"; do record_installed "$p"; done
            return 0
          fi
        fi
        warn "Retry failed."
        ;;
      s|S)
        warn "Skipping $pkgs_txt"
        for p in "${pkgs[@]}"; do record_skipped "$p"; done
        return 0
        ;;
      e|E) die "Aborted by user." ;;
      *) echo "  Please answer r, s, or e." ;;
    esac
  done
}

# Doctor check for a single binary
check_binary() {
  local bin="$1"
  local desc="${2:-$1}"
  if command -v "$bin" >/dev/null 2>&1; then
    local ver
    ver=$("$bin" --version 2>/dev/null | head -1 || true)
    ok "$desc: $ver"
    return 0
  else
    err "$desc: MISSING"
    return 1
  fi
}

# ──────────────────────────── Domain package maps ─────────────────────────

install_core_deps() {
  local pkgs=()
  for bin in git curl fzf ripgrep fd lazygit gh; do
    if ! command -v "$bin" >/dev/null 2>&1; then
      pkgs+=("$bin")
    fi
  done
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

install_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    ok "Neovim already installed ($(nvim --version | head -1))"
    record_installed "neovim"
    return 0
  fi
  if command -v nix >/dev/null 2>&1; then
    say "Nix found — recommending flake install instead."
    record_skipped "neovim (nix present)"
    return 0
  fi
  install_pkgs "neovim"
}

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

# ──────────────────────────── Doctor Mode ──────────────────────────────────

doctor_check() {
  say "=== Doctor: System Health Check ==="
  echo

  local issues=0

  say "--- Core binaries ---"
  check_binary git "git"              || ((issues++))
  check_binary curl "curl"            || ((issues++))
  check_binary fzf "fzf"              || ((issues++))
  check_binary rg "ripgrep (rg)"      || ((issues++))
  check_binary fd "fd/fdfind"         || ((issues++))
  check_binary lazygit "lazygit"      || ((issues++))
  check_binary gh "GitHub CLI (gh)"   || ((issues++))
  check_binary nvim "Neovim"          || ((issues++))

  say "--- Language toolchains ---"
  check_binary go "Go"                || ((issues++))
  check_binary rustup "Rust (rustup)" || ((issues++))
  check_binary node "Node.js"         || ((issues++))
  check_binary npm "npm"              || ((issues++))
  check_binary python3 "Python 3"     || ((issues++))
  check_binary pip3 "pip3"            || ((issues++))

  say "--- Config & Data ---"
  if [ -d "$CONFIG_DIR/.git" ]; then
    local commit
    commit=$(git -C "$CONFIG_DIR" log -1 --format="%H" 2>/dev/null || echo "unknown")
    ok "RehamVim config: $CONFIG_DIR (commit: ${commit:0:12})"
  elif [ -d "$CONFIG_DIR" ]; then
    warn "Config dir exists but not a git repo: $CONFIG_DIR"
    ((issues++))
  else
    err "RehamVim config NOT installed at $CONFIG_DIR"
    ((issues++))
  fi

  if [ -d "$HOME/.local/share/nvim/lazy" ]; then
    ok "Lazy plugins dir: ~/.local/share/nvim/lazy"
  else
    warn "Lazy plugins dir missing (will be created on first run)"
  fi

  echo
  if [ $issues -eq 0 ]; then
    ok "All checks passed ✓"
  else
    err "Found $issues issue(s) — run installer without --doctor to fix"
  fi
  return $issues
}

# ────────────────────────────────── Main ──────────────────────────────────

detect_pm

if [ $DOCTOR -eq 1 ]; then
  doctor_check
  exit $?
fi

# 0. Core tools
install_core_deps

# 1. Neovim (recommended)
if [ $UNATTENDED -eq 1 ] || [ ! -t 0 ]; then
  install_neovim
else
  read -r -p "Install Neovim if missing? [Y/n]: " -n 1 do_nvim </dev/tty
  echo
  case "${do_nvim}" in
    n|N) warn "Skipping Neovim install."; record_skipped "neovim" ;;
    *) install_neovim ;;
  esac
fi

# 2. Languages (interactive)
LANG_CHOICES="Go
Rust
Node.js
Python"

if command -v fzf >/dev/null 2>&1 && [ -t 0 ] && [ $UNATTENDED -eq 0 ]; then
  say "Pick languages to install (TAB/Space to select, Enter to continue, Esc to skip):"
  selected=$(printf '%s\n' "$LANG_CHOICES" | fzf --multi || true)
  if [ -n "$selected" ]; then
    mapfile -t sel_names <<<"$selected"
    lang_pkgs=()
    for line in "${sel_names[@]}"; do
      lang_pkgs+=("${line%%:*}")
    done
    install_languages "${lang_pkgs[@]}"
  else
    warn "No languages selected — skipping."
    record_skipped "languages"
  fi
elif [ $UNATTENDED -eq 1 ]; then
  warn "Unattended mode — skipping language selection (use manual install)."
  record_skipped "languages"
else
  warn "fzf unavailable or non-interactive — skipping language install."
  record_skipped "languages"
fi

# 3. Clone / update config
if [ -d "$CONFIG_DIR/.git" ]; then
  say "Existing RehamVim install found — updating."
  if [ $UNATTENDED -eq 1 ] || [ $DRY_RUN -eq 1 ] || [ ! -t 0 ]; then
    run git -C "$CONFIG_DIR" pull --ff-only
  elif confirm_cmd git -C "$CONFIG_DIR" pull --ff-only; then
    run git -C "$CONFIG_DIR" pull --ff-only
  else
    warn "Skipped update by user."
    record_skipped "config-update"
  fi
  if [ $DRY_RUN -eq 1 ]; then
    :
  elif [ -d "$CONFIG_DIR/.git" ] && git -C "$CONFIG_DIR" rev-parse --verify HEAD >/dev/null 2>&1; then
    ok "Config updated"
    record_installed "config-update"
  else
    warn "Could not auto-update; run 'git -C $CONFIG_DIR pull' later."
    record_skipped "config-update"
  fi
else
  if [ -d "$CONFIG_DIR" ]; then
    warn "Config directory exists but is not a git repo: $CONFIG_DIR"
    if [ $UNATTENDED -eq 1 ]; then
      backup="${CONFIG_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
      run cp -r "$CONFIG_DIR" "$backup" && ok "Backup created: $backup"
      run rm -rf "$CONFIG_DIR"
    else
      read -r -p "  (b)ackup, (o)verwrite, (c)ancel? [b/o/c]: " -n 1 reply </dev/tty
      echo
      case "$reply" in
        c|C) die "Cancelled." ;;
        b|B)
          backup="${CONFIG_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
          run cp -r "$CONFIG_DIR" "$backup" && ok "Backup created: $backup" || die "Backup failed."
          run rm -rf "$CONFIG_DIR" ;;
        o|O) run rm -rf "$CONFIG_DIR" ;;
        *) die "Invalid option." ;;
      esac
    fi
  fi
  say "Cloning RehamVim into $CONFIG_DIR..."
  if [ $UNATTENDED -eq 1 ] || [ $DRY_RUN -eq 1 ] || [ ! -t 0 ]; then
    run git clone "$REPO_URL" "$CONFIG_DIR"
  elif confirm_cmd git clone "$REPO_URL" "$CONFIG_DIR"; then
    run git clone "$REPO_URL" "$CONFIG_DIR"
  else
    warn "Skipped config clone by user."
    record_skipped "config-clone"
  fi
  if [ -d "$CONFIG_DIR/.git" ]; then
    ok "Config cloned"
    record_installed "config-clone"
    # Verify commit
    commit=$(git -C "$CONFIG_DIR" log -1 --format="%H" 2>/dev/null || echo "unknown")
    say "Cloned commit: ${commit:0:12}"
  elif [ $DRY_RUN -eq 1 ]; then
    :
  else
    die "Clone failed."
  fi
fi

# ──────────────────────────── Summary ────────────────────────────────────

echo
say "=== Installation Summary ==="

if [ ${#INSTALLED[@]} -gt 0 ]; then
  ok "Installed (${#INSTALLED[@]}):"
  for item in "${INSTALLED[@]}"; do
    printf '  ✓ %s\n' "$item"
  done
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
  warn "Skipped (${#SKIPPED[@]}):"
  for item in "${SKIPPED[@]}"; do
    printf '  ⊘ %s\n' "$item"
  done
fi

if [ ${#FAILED[@]} -gt 0 ]; then
  err "Failed (${#FAILED[@]}):"
  for item in "${FAILED[@]}"; do
    printf '  ✗ %s\n' "$item"
  done
fi

echo
ok "RehamVim is ready! cd ~/ && nvim to start."
ok "On first run, Lazy installs all plugins automatically."