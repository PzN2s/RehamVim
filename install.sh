#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}"
cat <<'EOF'
 ██╗ ██╗      ██╗   ██╗██╗███╗   ███╗   
████████╗     ██║   ██║██║████╗ ████║   
╚██╔═██╔╝     ██║   ██║██║██╔████╔██║   
████████╗     ╚██╗ ██╔╝██║██║╚██╔╝██║   
╚██╔═██╔╝      ╚████╔╝ ██║██║ ╚═╝ ██║██╗
 ╚═╝ ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝
EOF
echo -e "${NC}"

echo -e "${CYAN}[START] RehamVim Dependency Installer for Linux${NC}"
echo -e "${CYAN}===========================================${NC}"

if ! command -v git &>/dev/null; then
  echo -e "${RED}[ERROR] git is not installed${NC}"
  exit 1
fi

# Define Package Manager Base Command
if command -v paru &>/dev/null; then
  PM_CMD="paru"
  echo -e "${GREEN}[OK] Detected paru package manager${NC}"
elif command -v yay &>/dev/null; then
  PM_CMD="yay"
  echo -e "${GREEN}[OK] Detected yay package manager${NC}"
else
  echo -e "${RED}[ERROR] No AUR helper found. Please install paru or yay.${NC}"
  exit 1
fi

# --- FUNCTION TO HANDLE CONFLICTS ---
install_safe() {
  local pkgs="$@"
  local install_cmd="$PM_CMD -S --noconfirm --needed $pkgs"

  echo -e "${YELLOW}[PKG] Attempting to install: $pkgs${NC}"

  # Try automatic install first.
  if ! $install_cmd; then
    echo -e "${RED}[ERROR] Automatic installation failed for: $pkgs${NC}"
    echo -e "${YELLOW}This usually happens due to package conflicts or unavailable package names.${NC}"

    while true; do
      echo -e "${PURPLE}How would you like to proceed?${NC}"
      echo "  (r) Retry interactively (allows resolving conflicts manually)"
      echo "  (s) Skip this package and continue"
      echo "  (e) Exit installer"
      # Forces read to use the keyboard
      read -p "Selection [r/s/e]: " -n 1 -r </dev/tty
      echo

      case $REPLY in
      [Rr]*)
        echo -e "${BLUE}  Retrying interactively... (Answer 'y' to replace conflicts)${NC}"
        # Forces the package manager to use the keyboard
        if $PM_CMD -S --needed $pkgs </dev/tty; then
          echo -e "${GREEN}[OK] $pkgs installed successfully${NC}"
          return 0
        else
          echo -e "${RED}[ERROR] Interactive retry failed.${NC}"
        fi
        ;;
      [Ss]*)
        echo -e "${YELLOW}[WARN] Skipping $pkgs${NC}"
        return 0
        ;;
      [Ee]*)
        echo -e "${RED}[FATAL] Installation aborted by user.${NC}"
        exit 1
        ;;
      *) echo "Please enter r, s, or e." ;;
      esac
    done
  else
    echo -e "${GREEN}[OK] $pkgs installed successfully${NC}"
  fi
}

if ! command -v fzf &>/dev/null; then
  echo -e "${YELLOW}[PKG] Installing fzf for selection interface...${NC}"
  install_safe fzf
fi

echo -e "${YELLOW}[PKG] Installing external tools: github-cli, ripgrep, fd, lazygit...${NC}"
install_safe github-cli ripgrep fd lazygit

languages=("Go:go" "Rust:rustup" "Node.js:nodejs npm" "Python:python python-pip")

echo -e "${PURPLE}[TOOLS] Select languages to install (use TAB/Space to select, Enter to confirm):${NC}"

# --- FIXED LINE BELOW: REMOVED < /dev/tty SO THE PIPE WORKS AGAIN ---
selected=$(printf '%s\n' "${languages[@]}" | fzf --multi --header "Supported Languages" --color=fg:#d0d0d0,bg:#121212,hl:#5f87af --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff --color=marker:#87ff00,spinner:#af5fff,header:#87afaf || true)

if [ -z "$selected" ]; then
  echo -e "${YELLOW}[WARN] No languages selected.${NC}"
else
  echo -e "${YELLOW}[PKG] Installing selected languages...${NC}"
  while IFS= read -r sel; do
    pkg=$(echo "$sel" | cut -d: -f2)
    install_safe $pkg
  done <<<"$selected"
fi

echo -e "${PURPLE}[REPO] Setting up RehamVim config...${NC}"
CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="https://github.com/PzN2s/RehamVim.git"

if [ -d "$CONFIG_DIR" ]; then
  echo -e "${YELLOW}[WARN] Config directory $CONFIG_DIR already exists.${NC}"
  read -p "Do you want to (b)ackup, (o)verwrite, or (c)ancel? [b/o/c]: " -n 1 -r </dev/tty
  echo

  if [[ $REPLY =~ ^[Cc]$ ]]; then
    echo -e "${YELLOW}[INFO] Installation cancelled${NC}"
    exit 0
  elif [[ $REPLY =~ ^[Bb]$ ]]; then
    BACKUP_DIR="${CONFIG_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    echo -e "${BLUE}  Creating backup to $BACKUP_DIR...${NC}"
    cp -r "$CONFIG_DIR" "$BACKUP_DIR" || {
      echo -e "${RED}[ERROR] Failed to create backup${NC}"
      exit 1
    }
    echo -e "${GREEN}  [OK] Backup created${NC}"
    rm -rf "$CONFIG_DIR"
  elif [[ $REPLY =~ ^[Oo]$ ]]; then
    echo -e "${BLUE}  Removing existing directory...${NC}"
    rm -rf "$CONFIG_DIR"
  else
    echo -e "${RED}[ERROR] Invalid option. Installation cancelled.${NC}"
    exit 1
  fi

  echo -e "${BLUE}  Cloning RehamVim...${NC}"
  git clone "$REPO_URL" "$CONFIG_DIR" || {
    echo -e "${RED}[ERROR] Failed to clone repo${NC}"
    exit 1
  }
else
  echo -e "${BLUE}  Cloning RehamVim...${NC}"
  git clone "$REPO_URL" "$CONFIG_DIR" || {
    echo -e "${RED}[ERROR] Failed to clone repo${NC}"
    exit 1
  }
fi

echo -e "${GREEN}[DONE] RehamVim config ready! Run 'nvim' to start.${NC}"
