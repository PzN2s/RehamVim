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

```
init.lua               — Entry point; disables netrw, enables vim.loader
lua/
  config/
    lazy.lua           — lazy.nvim bootstrap + plugin spec imports
    extras.lua         — LazyVim extras imports (lang, coding, test, etc.)
    options.lua        — Neovim options (conceallevel, wrap, shell, guifont)
    autocmds.lua       — Autocommands (colorscheme persistence, dir open behavior)
    keymaps.lua        — Custom keymaps (Lazy menus, code runner, right-click menu)
  core/
    utils.lua          — run_code() and bootstrap_project() utilities
  plugins/
    ai/opencode.lua    — opencode.nvim AI agent config
    core/              — lualine, store, treesitter, which-key
    dap/nvim-dap.lua   — DAP debugging keybindings + setup
    editing/           — markdown-preview, markview, refactoring
    lsp/               — Go LSP opts (golangcilint ignore_exitcode quirk)
    testing/           — neotest-go, neotest-rust
    tools/             — cord, emojis, gh-dash, godoc, lazygit, mason, term, typr
    ui/                — bufferline, colorscheme, dashboard, icons, menu, notifications, telescope, tree, trouble
colors/                 — hand-built Reham Mist colorscheme (colors/reham_mist.lua)
flake.nix              — Nix flake packaging; sets NVIM_APPNAME=rehamvim
lazyvim.json           — LazyVim extras manifest (used by :LazyExtras)
lazy-lock.json         — Locked plugin versions
stylua.toml            — Lua formatter config
```

---

## Plugin Spec Pattern

Every plugin file under `lua/plugins/` returns a **LazyVim spec** (array of plugin tables). All files use `---@type LazySpec` annotations.

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
`lua/config/autocmds.lua` writes the current colorscheme name to `stdpath("data")/last_colorscheme` on `ColorScheme` event. `lua/plugins/ui/colorscheme.lua` reads this file at load time and defaults to `reham_mist`.

### Snacks vs nvim-tree dashboard behavior
When opening nvim with a directory argument, `lua/config/autocmds.lua` manually opens **both** nvim-tree and snacks dashboard via a `UIEnter` autocmd. The reason: snacks' own setup skips the dashboard when `argv > 0`, and setting `snacks.explorer.enabled = true` would open snacks' file picker instead of the dashboard. Keep `snacks.explorer.enabled = false`.

In `lua/plugins/ui/tree.lua`, the `<leader>e` keymap is mapped to nvim-tree. The snacks explorer keymaps `<leader>e` and `<leader>E` are explicitly set to `false` to avoid conflict.

### nvim-tree custom on_attach
The `on_attach` in `lua/plugins/ui/tree.lua` maps `l` to open files (instead of default `<CR>`) and `u` to go up. These are intentional UX choices.

### golangcilint exit code suppression
`lua/plugins/lsp/go.lua` sets `ignore_exitcode = true` for `golangcilint` in nvim-lint. This is because golangci-lint v2 exits with code 3 on SIGINT (used by nvim-lint's cancel mechanism), which would produce spurious error notifications even though real lint results are still parsed from JSON stdout correctly.

### OpenCode AI integration
`lua/plugins/ai/opencode.lua` configures the opencode.nvim plugin extensively. Key prefix is `<leader>o`. The preferred picker is `snacks` and completion is `blink`. Default mode is `build`. Context includes diagnostics (warnings + errors), current file, selections, and files.

### Dap json_decode override
`lua/plugins/dap/nvim-dap.lua` overrides `dap.ext.vscode.json_decode` to use plenary's json parser (which strips comments) instead of the default. This is required for `.vscode/launch.json` files that contain JSON comments.

### Right-click menu
`lua/config/keymaps.lua` maps `<RightMouse>` globally to open a smart context menu. It suppresses the menu on dashboard buffers, top-screen rows, and non-window contexts.

### Shell is fish, not bash
`lua/config/options.lua` sets `vim.opt.shell = "fish"` on non-Windows. This affects how shell commands (including code runner) execute. The `shellcmdflag = "-c"` and empty quotes handle fish's CLI interface.

---

## Code Style

- **Lua formatter**: stylua (see `stylua.toml`). Run `stylua --config-path stylua.toml lua/` to format.
- **Annotations**: LazyVim-style `---@type LazySpec` / `---@type LazyVimConfig` annotations used throughout.
- **Comments**: Inline `-- NOTE:` and `-- NOTE: File Tree and Explorer` style headers to identify plugin sections.
- **Conditional plugin loading**: Use `vim.fn.has("win32") == 1` for Windows-specific paths (e.g., shell, path separators).

---

## Testing

- `neotest-go` and `neotest-rust` are configured in `lua/plugins/testing/`.
- Use `:Neotest` commands to run tests. No standalone test runner for the Neovim config itself.

---

## LazyVim Integration Points

This config is built on LazyVim. Key integration points:

- `lazyvim.json` — extras manifest; synced with `lua/config/extras.lua`.
- `LazyVim.config.icons` — icon sets used in lualine and other plugins.
- `LazyVim.opts("plugin-name")` — retrieve a plugin's opts table (used in dap config for mason-nvim-dap).
- `LazyVim.lualine.root_dir()` / `LazyVim.lualine.pretty_path()` — lualine extensions from LazyVim.
- `LazyVim.has("plugin-name")` — check if a plugin is installed.
