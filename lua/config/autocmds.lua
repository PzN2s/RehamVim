local group = vim.api.nvim_create_augroup("RehamVim", { clear = true })

local profile = require("config.profile")

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    local file = vim.fn.stdpath("data") .. "/last_colorscheme"
    local name = string.lower(vim.g.colors_name or ""):gsub(" ", "_")
    vim.fn.writefile({ name }, file)
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
