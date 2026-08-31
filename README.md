<div align="center">

<br>

# ⬛ RehamVim

**a quiet, personal Neovim — built on [LazyVim](https://lazyvim.github.io).**

<br>

[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-ffffff?style=for-the-badge&logo=neovim&logoColor=white&labelColor=111111)](https://github.com/neovim/neovim)
[![Lua](https://img.shields.io/badge/Lua-5.1%2B-ffffff?style=for-the-badge&logo=lua&logoColor=white&labelColor=111111)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-ffffff?style=for-the-badge&logoColor=white&labelColor=111111)](LICENSE)
[![Nix](https://img.shields.io/badge/Nix-Flake-ffffff?style=for-the-badge&logo=nixos&logoColor=white&labelColor=111111)](flake.nix)
[![Last commit](https://img.shields.io/github/last-commit/PzN2s/RehamVim?style=for-the-badge&color=ffffff&labelColor=111111)](https://github.com/PzN2s/RehamVim)

<br>

</div>

---

**RehamVim** is a fast, curated Neovim configuration with one hand-built
monochrome colorscheme, deep language support, and **zero AI** — just you and
the editor. It installs in seconds, stays out of your way, and gets out of the
way of the rest of your system.

---

## ◻ Highlights

| | Feature |
| --- | --- |
| ▫ | **Single colorscheme** — Reham Mist, hand-built to match your desktop. |
| ▫ | **No AI** — no Copilot, no assistants, no noise. |
| ▫ | **Deep language support** — Go, Rust, TypeScript, Python out of the box. |
| ▫ | **Isolated install** — a dedicated `rehamvim` binary (Nix), zero clashes. |
| ▫ | **Curated tooling** — lazygit, telescope, treesitter, dap, lualine. |
| ▫ | **Plug & play** — clone, open, done. Lazy handles the rest. |

---

## ◻ Reham Mist

The one colorscheme it ships with is a **quiet, high-contrast monochrome**
palette: pure black, near-white text, and a cool grey ramp with a single soft
accent — designed to sit naturally next to the rest of your desktop chrome.

```lua
:colorscheme reham_mist
```

Switch live any time with `:Telescope colorscheme`.

---

## ◻ Installation

**Prerequisites:** Neovim ≥ 0.12, `git`, `curl`, and the compilers your LSPs
need (`gcc`, `make`, `clang`).

> [!WARNING]
> Your current `~/.config/nvim` is backed up — never destroyed.

**Linux / macOS**

```sh
bash <(curl -s https://raw.githubusercontent.com/PzN2s/RehamVim/main/install.sh)
```

**Windows (PowerShell)**

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/PzN2s/RehamVim/main/install.ps1 -UseBasicParsing | Invoke-Expression
```

The installer detects your package manager, installs the essentials
(`ripgrep`, `fd`, `lazygit`, `gh`), and asks which languages you want.

**Manual**

```sh
git clone https://github.com/PzN2s/RehamVim ~/.config/nvim
nvim
```

Lazy.nvim fetches and configures every plugin on first launch.

---

## ◻ Nix

Ships a `flake.nix` exposing an isolated `rehamvim` binary — no interference
with your system Neovim.

```sh
# try without installing
nix run github:PzN2s/RehamVim
```

Or add it to your flake:

```nix
{
  inputs = {
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-unstable";
    rehamvim.url = "github:PzN2s/RehamVim";
  };

  home.packages = [
    inputs.rehamvim.packages.${pkgs.system}.default
  ];
}
```

> [!NOTE]
> The config lives in `/nix/store`; `rehamvim` is the entry point.

---

## ◻ Key Bindings

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

Full set at `:Telescope keymaps` or `<leader>sk`.

---

## ◻ Supported Languages

| Language | LSP | Debug | Test | Format |
| --- | :---: | :---: | :---: | :---: |
| Go             | ✅ | ✅ | ✅ | ✅ |
| Rust           | ✅ | ✅ | ✅ | ✅ |
| TypeScript / JS| ✅ | — | — | ✅ |
| Python         | ✅ | — | — | ✅ |

---

## ◻ Layout

```
~/.config/nvim
├── init.lua
├── flake.nix            # isolated rehamvim binary
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

## ◻ Contributing

Found a bug or want something better? Open an issue or a pull request. Keep it
minimal, keep it fast — that's the spirit of this config.

---

<div align="center">

<sub>Apache-2.0 · Copyright © 2026 Reham</sub>

</div>
