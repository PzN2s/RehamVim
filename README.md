<div align="center">

# RehamVim

a quiet, personal Neovim — built on [LazyVim](https://lazyvim.github.io).

[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-ffffff?style=for-the-badge&logo=neovim&logoColor=white&labelColor=111111)](https://github.com/neovim/neovim)
[![Lua](https://img.shields.io/badge/Lua-5.1%2B-ffffff?style=for-the-badge&logo=lua&logoColor=white&labelColor=111111)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-ffffff?style=for-the-badge&logoColor=white&labelColor=111111)](LICENSE)
[![Nix](https://img.shields.io/badge/Nix-Flake-ffffff?style=for-the-badge&logo=nixos&logoColor=white&labelColor=111111)](flake.nix)
[![Last commit](https://img.shields.io/github/last-commit/PzN2s/RehamVim?style=for-the-badge&color=ffffff&labelColor=111111)](https://github.com/PzN2s/RehamVim)

</div>

**RehamVim** is a fast, curated Neovim configuration with deep language
support. I wanted something fast and simple that just runs without fighting
my system. That's basically it.

<div align="center">

<a href="image.png"><img src="image.png" width="48%" alt="RehamVim — dashboard"></a>
<a href="iage.png"><img src="iage.png" width="48%" alt="RehamVim — editing"></a>
<br><br>
<a href="imge.png"><img src="imge.png" width="96%" alt="RehamVim — full setup"></a>
<br><br>
<a href="Colorscheme.png"><img src="Colorscheme.png" width="96%" alt="RehamVim — colorscheme"></a>

</div>

## ○ Highlights

| | Feature |
| --- | --- |
| ○ | **Deep language support** — Go, Rust, TypeScript, Python out of the box. |
| ○ | **Isolated install** — a dedicated `rehamvim` binary (Nix), zero clashes. |
| ○ | **Curated tooling** — lazygit, telescope, treesitter, dap, lualine. |
| ○ | **Plug & play** — clone, open, done. Lazy handles the rest. |

## ○ Installation

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

> [!NOTE]
> **Confirmation before every install.** In interactive terminals the installer
> asks you to confirm each download and install command before it runs — package
> installs, `git clone`/`pull`, and `apt-get update`. Press `n` to skip any step
> you don't want. Non-interactive modes bypass the prompts and run straight
> through, safe for CI.

Need to inspect before you commit, or diagnose an existing setup?

```sh
# diagnose an existing install without changing anything
bash install.sh --doctor

# preview exactly what will run, executing nothing
bash install.sh --dry-run

# non-interactive install (CI / scripting) — no prompts, no confirmation
bash install.sh --unattended
```

Running without an option starts an interactive install: every package,
download, and clone is confirmed before it runs.

Removing RehamVim later is a one-liner (config is backed up first):

```sh
bash uninstall.sh                  # remove config + data + state + cache
bash uninstall.sh --remove-langs   # ...and installed language toolchains
```

**Manual**

```sh
git clone https://github.com/PzN2s/RehamVim ~/.config/nvim
nvim
```

Lazy.nvim fetches and configures every plugin on first launch.

## ○ Nix

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

## ○ Key Bindings

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

## ○ Supported Languages

| Language | LSP | Debug | Test | Format |
| --- | :---: | :---: | :---: | :---: |
| Go             | ☑ | ☑ | ☑ | ☑ |
| Rust           | ☑ | ☑ | ☑ | ☑ |
| TypeScript / JS| ☑ | ○ | ○ | ☑ |
| Python         | ☑ | ○ | ○ | ☑ |

## ○ Layout

```
~/.config/nvim
├── init.lua              # entry point
├── flake.nix             # isolated rehamvim binary
├── colors/               # 23 themes
├── lua/
│   ├── boot/             # startup wiring
│   │   ├── loader.lua    # lazy.nvim bootstrap + mods.* imports
│   │   ├── opts.lua      # neovim options
│   │   ├── events.lua    # autocmds
│   │   ├── keys.lua      # keymaps
│   │   ├── profile.lua   # Session Profiles (auto-detect / override)
│   │   └── extras.lua    # LazyVim extras
│   ├── lib/              # shared utils
│   └── mods/             # plugin specs by domain
│       ├── view/         # dashboard, tree, telescope, trouble, menu
│       ├── status/       # lualine, which-key
│       ├── edit/         # markdown, refactoring, markview
│       ├── langs/        # self-contained per-language modules
│       ├── vcs/          # lazygit, gh-dash, godoc
│       ├── tools/        # mason, cord, term, typr
│       └── debug/        # DAP
└── lazy-lock.json        # pinned plugin versions
```

## ○ Contributing

Found a bug or want something better? Open an issue or a pull request. Keep it
minimal, keep it fast — that's the spirit of this config.

<div align="center">

<sub>Apache-2.0 · Copyright © 2026 Reham</sub>

</div>
