local group = vim.api.nvim_create_augroup("RehamVim", { clear = true })

local profile = require("boot.profile")

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local name = string.lower(vim.g.colors_name or ""):gsub(" ", "_")
    vim.fn.writefile({ name }, file)
    -- Re-assert tree links after every apply: in some re-apply paths
    -- (wal watcher, picker previews) linked groups were observed missing
    -- afterwards, leaving the tree unstyled. Idempotent and harmless.
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { link = "NeoTreeNormal" })
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { link = "NeoTreeDirectoryName" })
    vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { link = "NeoTreeRootName" })
  end,
})

vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  group = group,
  callback = function()
    vim.defer_fn(function()
      profile.refresh()
    end, 50)
  end,
})

-- Distinctive WorkSpace label, shown ONLY on the file-tree window (no tabline).
-- Title highlight (wal accent) for the Saturn icon, subtle WinBar for text.
-- BufWinEnter (not FileType): nvim-tree displays the window after setting the
-- filetype, so FileType-time vim.wo would hit the wrong window.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= "NvimTree" then
      return
    end
    for _, w in ipairs(vim.fn.win_findbuf(ev.buf)) do
      -- Centered, no background box: safe to center now (nothing to clip).
      -- Eye icon via nr2char (Nerd Font, single cell): a literal emoji has
      -- ambiguous width and pulled the label slightly left of center.
      vim.wo[w].winbar = "%=%#Normal#Work" .. vim.fn.nr2char(0xF06E) .. "Space%="
    end
  end,
})
-- Dashboard design force-apply (merge-proof). Background: lazy.nvim merges
-- same-plugin opts by table position, which silently lets LazyVim core
-- defaults overwrite list values (keys/header/sections) no matter the import
-- order. Since dashboard.open() reads Snacks.config.dashboard live on every
-- open, assigning our table here always wins. (User LazyDone proved
-- unreliable -- it never fires -- so this hooks VimEnter instead.)
-- Dashboard design authority (merge-proof). The snacks spec already returns
-- lib.dashboard_cfg, so the first paint is correct; this only re-asserts
-- the same table. (An old version deleted + reopened the dashboard here to
-- repaint it, but that split the window instead of reusing it.)
vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    local ok_s, Snacks = pcall(require, "snacks")
    if not ok_s then
      return
    end
    local ok_c, cfg = pcall(require, "lib.dashboard_cfg")
    if ok_c and type(cfg) == "table" then
      Snacks.config.dashboard = cfg
    end
  end,
})

-- (pywal follow removed with the reham_wal theme: no wallpaper watching here.)

-- On `nvim <directory>`: open nvim-tree sidebar on the right AND snacks
-- dashboard as the start screen. Snacks' own setup skips the dashboard when
-- argv > 0 (snacks/dashboard.lua:1131), and the explorer.skip-dashboard branch
-- only fires when explorer.enabled = true — so we open both manually here.
vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  callback = function()
    for _, arg in ipairs(vim.fn.argv()) do
      if vim.fn.isdirectory(vim.fn.fnamemodify(arg, ":p")) == 1 then
        -- Force both plugins to load + configure synchronously before opening,
        -- so they appear together instead of one hitching in after the other.
        -- Plugin names: lazy.nvim uses the raw spec string for name resolution
        -- (lazy.nvim/lua/lazy/core/fragments.lua).
        require("lazy").load({ plugins = { "nvim-tree.lua", "snacks.nvim" } })
        require("nvim-tree.api").tree.open()
        require("snacks.dashboard").open()
        break
      end
    end
  end,
})
