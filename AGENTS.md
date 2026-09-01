# RehamVim — Neovim Configuration

**Type**: Neovim plugin configuration (LazyVim-based)
**APPNAME**: `rehamvim` (configured via `NVIM_APPNAME=rehamvim` in the flake)
**Plugin manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
**Formatter**: stylua (config at `stylua.toml`)

---

## Essential Commands

```bash
# Open nvim normally
nvim

# Open nvim with a directory (triggers nvim-tree + snacks dashboard auto-open)
nvim /path/to/dir

# Update plugins
nvim --headless "+Lazy! sync" +qa

# Check plugin health
nvim --headless "+Lazy! health" +qa

# Format all lua files
stylua --config-path stylua.toml lua/

# Build the nix flake (outputs rehamvim package)
nix build .#rehamvim
```

---

## Code Organization

RehamVim uses a custom layout (`boot/`, `lib/`, `mods/`) instead of LazyVim's
default `config/` + `plugins/` split. Plugin specs are grouped by **domain**,
and each language lives in a single self-contained module.

```
init.lua               — Entry point; disables netrw, enables vim.loader
lua/
  boot/
    loader.lua         — lazy.nvim bootstrap + plugin spec imports (mods.*)
    extras.lua         — LazyVim extras imports (lang, coding, test, etc.)
    opts.lua           — Neovim options (conceallevel, wrap, shell, guifont)
    events.lua         — Autocommands (colorscheme persistence, dir open behavior)
    keys.lua           — Custom keymaps (Lazy menus, code runner, right-click menu)
    profile.lua        — Session Profiles (auto-detect + .nvim-profile override)
  lib/
    utils.lua          — run_code() and bootstrap_project() utilities
  mods/
    view/              — Visual chrome: dashboard, bufferline, telescope, tree,
                         trouble, menu, notifications, icons
    status/            — Statusline & theme: lualine, which-key, colorscheme, store
    edit/              — Editing: treesitter, markview, markdown, refactor,
                         highlight-colors
    langs/             — Per-language self-contained modules:
                         go.lua (lsp+golangci-lint+neotest adapter),
                         rust.lua (rustaceanvim+crates+test adapter),
                         nix.lua, neotest.lua (base test keymaps)
    vcs/               — Version control: lazygit, gh-dash, godoc
    tools/             — Utilities: cord, emojis, term, typr, mason
    debug/             — DAP setup (dap.lua, nvim-dap override)
colors/                 — Reham theme family (23 themes: 6 base + 17 pure-black)
flake.nix              — Nix flake packaging; sets NVIM_APPNAME=rehamvim
lazyvim.json           — LazyVim extras manifest (used by :LazyExtras)
lazy-lock.json         — Locked plugin versions
stylua.toml            — Lua formatter config
```

---

## Plugin Spec Pattern

Every plugin file under `lua/mods/` returns a **LazyVim spec** (array of plugin tables). All files use `---@type LazySpec` annotations.

```lua
---@type LazySpec
return {
  { "plugin/plugin-name", opts = {}, keys = {}, ... },
}
```

**Key plugin override conventions**:

- `lazy = true` (default) — only load when first needed. Set `lazy = false` to load on startup.
- `event = "VeryLazy"` — load after startup is complete (preferred over lazy=false for non-critical plugins).
- `cmd` / `keys` — lazy-load triggers.
- `opts` — passed to plugin's `setup()` call (or module opts if no setup function).
- `config` — runs after plugin loads (use for manual `require("x").setup({})` calls).
- `dependencies` — list of plugins to load first.

**Conditional disabling**: Use `enabled = false` on any spec entry.

---

## Important Gotchas & Quirks

### Colorscheme persistence
`lua/boot/events.lua` writes the current colorscheme name to `stdpath("data")/last_colorscheme` on `ColorScheme` event. `lua/mods/status/colorscheme.lua` reads this file at load time, only accepts names matching `^reham_`, and defaults to `reham_mist`. All themes share a highlight engine in `lua/colorschemes/reham.lua` (`require("colorschemes.reham").define(name, palette)`); each `colors/reham_*.lua` only supplies its palette. The `<leader>uC` picker in `lua/boot/keys.lua` is filtered to `^reham_` and is a **custom floating list** (not `vim.ui.select`): a `▸` arrow marks the theme under the cursor and moves with `j`/`k`/`<Up>`/`<Down>` (wraps around); `<CR>` applies it, `q`/`<Esc>` closes, and it starts on the currently-active theme. The buffer is `modifiable=false` and the `▸` arrow is drawn with a **virt_text extmark** — never edit the buffer (stray key bytes like `<b8>` used to get INSERTED when the buffer was writable). Mappings are set for both normal and insert modes.

**Reham-only policy**: `colorscheme.lua` also disables the two themes LazyVim core bundles (`folke/tokyonight.nvim`, `catppuccin/nvim`) so they are pruned on `Lazy! sync`, and `loader.lua` uses `install.colorscheme = { "reham_mist" }`. Neovim's own runtime always ships ~28 built-in themes (`blue.vim`, `catppuccin.vim`, `habamax.vim`, ...); they cannot be removed from the installed package, so:
- `colors/` contains **shadow files** with the same names that are **silent no-ops** — `:colorscheme habamax` (or a picker previewing it) does nothing and the previous theme stays. **Exception: `default.vim` is never shadowed** — it is Neovim's baseline (e.g. `snacks.nvim` picker preview saves/restores via `vim.g.colors_name or "default"`). **Use silent no-ops, never `:echoerr` — hard errors have broken picker previews.**
- `colorscheme.lua` wraps `vim.fn.getcompletion` so `"color"` completions return only `reham_*` (covers `<leader>uC`, Telescope) and patches `snacks.picker.source.vim.colorschemes` (its themes picker scans `colors/*` via `globpath`, so it needs its own filter).
If Neovim ever adds new built-in themes, mirror their filenames in `colors/` (`.vim` for vim, `.lua` for lua).

Palettes may add optional **per-syntax keys** (`comment`, `string`, `number`, `constant`, `keyword`, `["function"]`, `type`, `operator`, `delimiter`, `tag`, `property`, `variable`, `directory`, `file`) applied via the post-pass block at the end of `M.define`. When absent, the base semantic colors are used, so the base family is unaffected. Note `function` is a Lua reserved word — the extended key must be written `["function"] = "#hex"` inside the palette table.

### Snacks vs nvim-tree dashboard behavior
When opening nvim with a directory argument, `lua/boot/events.lua` manually opens **both** nvim-tree and snacks dashboard via a `UIEnter` autocmd. The reason: snacks' own setup skips the dashboard when `argv > 0`, and setting `snacks.explorer.enabled = true` would open snacks' file picker instead of the dashboard. Keep `snacks.explorer.enabled = false`.

In `lua/mods/view/tree.lua`, the `<leader>e` keymap is mapped to nvim-tree. The snacks explorer keymaps `<leader>e` and `<leader>E` are explicitly set to `false` to avoid conflict.

### nvim-tree custom on_attach
The `on_attach` in `lua/mods/view/tree.lua` maps `l` to open files (instead of default `<CR>`) and `u` to go up. These are intentional UX choices.

### golangcilint exit code suppression
`lua/mods/langs/go.lua` sets `ignore_exitcode = true` for `golangcilint` in nvim-lint. This is because golangci-lint v2 exits with code 3 on SIGINT (used by nvim-lint's cancel mechanism), which would produce spurious error notifications even though real lint results are still parsed from JSON stdout correctly.

### Dap json_decode override
`lua/mods/debug/dap.lua` overrides `dap.ext.vscode.json_decode` to use plenary's json parser (which strips comments) instead of the default. This is required for `.vscode/launch.json` files that contain JSON comments.

### Right-click menu
`lua/boot/keys.lua` maps `<RightMouse>` globally to open a smart context menu. It suppresses the menu on dashboard buffers, top-screen rows, and non-window contexts.

### Shell is fish, not bash
`lua/boot/opts.lua` sets `vim.opt.shell = "fish"` on non-Windows. This affects how shell commands (including code runner) execute. The `shellcmdflag = "-c"` and empty quotes handle fish's CLI interface.

### Boot layer loads AFTER `lazy.setup`
`lua/boot/loader.lua` requires `boot.opts`, `boot.keys` and `boot.events` at the **end of `lazy.setup()`** (`init.lua` only requires `boot.loader`). This lets our custom options/keymaps/autocmds override LazyVim defaults. Do not move them before `setup()` (LazyVim would re-apply its own keymaps/options afterwards), and do not assume `boot.keys` works without this wiring — that bug left every custom keymap (`<leader>P*`, `<leader>uC`, right-click menu) silently dead.

### Update checker disabled (startup cost)
`loader.lua` sets `checker = { enabled = false }`. With it enabled, lazy.nvim ran an update check at every startup that git-fetches **each** installed plugin — ~30s startup and occasional hangs (exit hangs after `qa!`) on this machine. Startup is ~50ms now. Update manually with `:Lazy check` / `:Lazy update`.

### `boot.keys` mapping subtleties
- `<leader>` is stored expanded in keymap tables (`<Space>Pp`, not `<leader>Pp`), so `nvim_get_keymap("n")` returns `<Space>...` lhs, and `vim.fn.maparg` does **not** expand `<leader>`. Always check through `vim.keycode("<leader>Xx")`.
- Deleting LazyVim's `<leader>l` / `<leader>L` is now guarded (a bare `vim.keymap.del` throws `E31` when the mapping does not exist).
- `<leader>Pc` calls `LazyVim.news.changelog()` — the `:LazyVimChangelog` command no longer exists in current LazyVim.

### Notifications: snacks only
`lua/mods/view/notifications.lua` disables `folke/noice.nvim` (`enabled = false`) — notifications come from `snacks.notifier` alone. Running both produced duplicate toasts. Keep noice disabled.

### Bug Delta (feature)
`lua/boot/bugdelta.lua` (loaded last in `loader.lua`) diffs diagnostics after a save: `BufWritePre` snapshots the current buffer's diagnostics, `BufWritePost` (+400ms to let the LSP settle) reports newly introduced errors/warnings via `Snacks.notify` and a lualine `Δ+N`/`Δ0` marker (`vim.g.reham_bugdelta`). Commands: `:RehamBugDelta` (analyze now), `:RehamBugDeltaToggle` (on/off auto), `:RehamBugDeltaList` (loclist of new diagnostics). If no snapshot exists yet, inspection just establishes a baseline for the next save. Keep `auto`/`enabled` semantics: disabled = no autocmd work at all.

### Smart menu triggers
`lua/mods/view/menu.lua` (`nvzone/menu`) is `lazy = true` and must declare `cmd = { "OpenSmartMenu" }` — the user command is defined inside its `config()`, so without a trigger the plugin never loads and the command is missing (`<leader>cp` / right-click break). Keep it lazy.

---

## Code Style

- **Lua formatter**: stylua (see `stylua.toml`). Run `stylua --config-path stylua.toml lua/` to format.
- **Annotations**: LazyVim-style `---@type LazySpec` / `---@type LazyVimConfig` annotations used throughout.
- **Comments**: Inline `-- NOTE:` and `-- NOTE: File Tree and Explorer` style headers to identify plugin sections.
- **Conditional plugin loading**: Use `vim.fn.has("win32") == 1` for Windows-specific paths (e.g., shell, path separators).

---

## Testing

- Go/Rust test adapters live inside `lua/mods/langs/go.lua` and `lua/mods/langs/rust.lua`; base test keymaps in `lua/mods/langs/neotest.lua`.
- Use `:Neotest` commands to run tests. No standalone test runner for the Neovim config itself.

---

## LazyVim Integration Points

This config is built on LazyVim. Key integration points:

- `lazyvim.json` — extras manifest; synced with `lua/boot/extras.lua`.
- `LazyVim.config.icons` — icon sets used in lualine and other plugins.
- `LazyVim.opts("plugin-name")` — retrieve a plugin's opts table (used in dap config for mason-nvim-dap).
- `LazyVim.lualine.root_dir()` / `LazyVim.lualine.pretty_path()` — lualine extensions from LazyVim.
- `LazyVim.has("plugin-name")` — check if a plugin is installed.