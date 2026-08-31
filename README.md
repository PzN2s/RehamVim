<div align="center">

# RehamVim

**A fast, minimal, personal Neovim experience — built on [LazyVim](https://lazyvim.github.io).**

[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-blueviolet?style=for-the-badge&logo=neovim&logoColor=white&color=1e1e2e)](https://github.com/neovim/neovim)
[![License](https://img.shields.io/github/license/PzN2s/RehamVim?style=for-the-badge&color=1e1e2e)](LICENSE)
[![Last commit](https://img.shields.io/github/last-commit/PzN2s/RehamVim?style=for-the-badge&color=1e1e2e)](https://github.com/PzN2s/RehamVim)

</div>

---

## ✨ Highlights

- **One quiet colorscheme** — [Reham Mist](#-reham-mist), hand-built to match the rest of the desktop.
- **No AI** — no Copilot, no opencode, no assistants. Just you and the editor.
- **Deep language support** — Go, Rust, TypeScript, Python out of the box.
- **Isolated install** — run as its own `rehamvim` binary (Nix) with zero clashes.
- **Curated tooling** — lazygit, telescope, treesitter, dap, lualine, and more.
- **Plug & play** — clone, open, done. Lazy installs everything for you.

---

## 🎨 Reham Mist

The built-in colorscheme is a **quiet, high-contrast monochrome** palette:
pure black, near-white text, and a cool grey ramp with a single soft accent.

It was designed to sit naturally next to the surrounding desktop chrome —
no noise, no neon.

```lua
:colorscheme reham_mist
```

Or switch live with `:Telescope colorscheme`.

---

## 🚀 Installation

### Prerequisites

- **Neovim ≥ 0.12**
- **git**, **curl**, and the compilers your LSPs need (`gcc`, `make`, `clang`)
- For language LSPs: `npm`/`nodejs`, `go`, `rustup`, `python` — the installer lists them.

> [!WARNING]
> Your current `~/.config/nvim` will be backed up, not destroyed.

### One-liner (Linux/macOS)

```sh
bash <(curl -s https://raw.githubusercontent.com/PzN2s/RehamVim/main/install.sh)
```

### One-liner (Windows PowerShell)

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/PzN2s/RehamVim/main/install.ps1 -UseBasicParsing | Invoke-Expression
```

The installer:

1. Detects your package manager.
2. Installs the essentials: `ripgrep`, `fd`, `lazygit`, `gh`.
3. Lets you pick languages to support.
4. Backs up and clones the config into place.

### Manual

```sh
git clone https://github.com/PzN2s/RehamVim ~/.config/nvim
nvim
```

Lazy.nvim fetches and sets up every plugin on first launch.

---

## ❄️ Nix

RehamVim ships a `flake.nix` and exposes an isolated `rehamvim` binary — no
interference with your system Neovim.

```sh
# Try without installing
nix run github:PzN2s/RehamVim
```

Or add it to your own flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rehamvim.url = "github:PzN2s/RehamVim";
  };

  home.packages = [
    inputs.rehamvim.packages.${pkgs.system}.default
  ];
}
```

After switching, run `rehamvim` in your terminal.

> [!NOTE]
> The config lives in your `/nix/store`; the `rehamvim` binary is the entry point.

---

## 🧭 Key Bindings

| Keys | Action |
| --- | --- |
| `<leader>e` | Toggle file tree |
| `<leader>f` | Find files (Telescope) |
| `<leader>u` | UI-related commands |
| `<leader>t` | Terminal |
| `<leader>T` | Tests |
| `<leader>gu` | GitHub dashboard |
| `gcc` | Toggle comment |
| `<RightMouse>` | Smart context menu |

See the full set with `:Telescope keymaps` or `<leader>sk`.

---

## 🗂️ Supported Languages

| Language | LSP | Debug | Test | Format |
| --- | --- | --- | --- | --- |
| Go | ✅ | ✅ | ✅ | ✅ |
| Rust | ✅ | ✅ | ✅ | ✅ |
| TypeScript / JS | ✅ | — | — | ✅ |
| Python | ✅ | — | — | ✅ |

---

## 🌳 Project Layout

```
~/.config/nvim
├── init.lua
├── flake.nix            # Nix packaging (isolated rehamvim binary)
├── colors/              # Reham Mist colorscheme
├── lua/
│   ├── config/          # lazy, options, keymaps, autocmds
│   ├── core/            # utils
│   └── plugins/
│       ├── core/        # lualine, treesitter, which-key
│       ├── dap/         # debugging
│       ├── editing/     # markdown, refactoring
│       ├── lsp/         # language servers
│       ├── testing/     # neotest
│       ├── tools/       # lazygit, mason, gh-dash, cord
│       └── ui/          # bufferline, telescope, trouble, tree
└── lazy-lock.json       # pinned plugin versions
```

---

## 🤝 Contributing

Found a bug or want something better? Open an issue or a pull request.
Keep it minimal, keep it fast — that's the spirit of this config.

---

## 📄 License

Apache-2.0 — see [LICENSE](LICENSE). Copyright © 2026 Reham.
