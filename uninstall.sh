#!/usr/bin/env bash
# RehamVim uninstaller — removes config, data, and optionally language toolchains.

set -Eeuo pipefail

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

say()  { printf '%b\n' "${CYAN}[RehamVim]${RESET} $*"; }
ok()   { printf '%b\n' "${GREEN}[OK]${RESET} $*"; }
warn() { printf '%b\n' "${YELLOW}[WARN]${RESET} $*"; }
err()  { printf '%b\n' "${RED}[ERROR]${RESET} $*"; }

die() {
  err "$@"
  exit 1
}

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

REMOVE_LANGS=0
FORCE=0
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --remove-langs) REMOVE_LANGS=1 ;;
    --force|-y)     FORCE=1 ;;
    --dry-run)      DRY_RUN=1 ;;
    -h|--help)
      cat <<'EOF'
RehamVim Uninstaller

Usage: uninstall.sh [OPTIONS]

Options:
  --remove-langs   Also remove language toolchains (go, rustup, node, python packages)
  --force, -y      Non-interactive, skip confirmations
  --dry-run        Show what would be removed without doing it
  -h, --help       Show this help
EOF
      exit 0
      ;;
    *) die "Unknown option: $arg. Use --help for usage." ;;
  esac
done

run() {
  if [ $DRY_RUN -eq 1 ]; then
    say "[DRY-RUN] $*"
    return 0
  fi
  "$@"
}

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

say "RehamVim uninstaller"
echo

# Confirmation
if [ $FORCE -eq 0 ] && [ $DRY_RUN -eq 0 ]; then
  warn "This will remove:"
  echo "  - Config:    $CONFIG_DIR"
  echo "  - Data:      $DATA_DIR"
  echo "  - State:     $STATE_DIR"
  echo "  - Cache:     $CACHE_DIR"
  [ $REMOVE_LANGS -eq 1 ] && echo "  - Languages: go, rustup, node, python (via package manager)"
  echo
  read -r -p "Continue? [y/N]: " -n 1 confirm
  echo
  [[ $confirm =~ ^[Yy]$ ]] || die "Cancelled."
fi

# Backup config if it exists and is a git repo
if [ -d "$CONFIG_DIR/.git" ]; then
  backup="${CONFIG_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
  say "Backing up config to $backup..."
  run cp -r "$CONFIG_DIR" "$backup" && ok "Backup created: $backup"
fi

# Remove directories
for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
  if [ -d "$dir" ]; then
    say "Removing $dir..."
    run rm -rf "$dir" && ok "Removed $dir"
  else
    say "$dir not found — skipping."
  fi
done

# Optionally remove language toolchains
if [ $REMOVE_LANGS -eq 1 ]; then
  say "Removing language toolchains..."
  if command -v paru >/dev/null 2>&1 || command -v yay >/dev/null 2>&1 || command -v pacman >/dev/null 2>&1; then
    run sudo pacman -Rns --noconfirm go rustup nodejs npm python-pip 2>/dev/null || true
    ok "Arch packages removed"
  elif command -v apt-get >/dev/null 2>&1; then
    run sudo apt-get remove -y golang-go rustup nodejs npm python3-pip 2>/dev/null || true
    ok "Debian/Ubuntu packages removed"
  elif command -v dnf >/dev/null 2>&1; then
    run sudo dnf remove -y golang rustup nodejs npm python3-pip 2>/dev/null || true
    ok "Fedora packages removed"
  elif command -v zypper >/dev/null 2>&1; then
    run sudo zypper remove -y go rustup nodejs npm python3-pip 2>/dev/null || true
    ok "openSUSE packages removed"
  elif command -v xbps-install >/dev/null 2>&1; then
    run sudo xbps-remove -y go rustup nodejs npm python3-pip 2>/dev/null || true
    ok "Void packages removed"
  else
    warn "No supported package manager found for language removal."
  fi
fi

echo
ok "Uninstall complete."
[ $DRY_RUN -eq 1 ] && warn "Dry-run mode — nothing was actually removed."