local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "boot.extras" },
    { import = "mods.langs" },
    { import = "mods.view" },
    { import = "mods.tools" },
    { import = "mods.status" },
    { import = "mods.edit" },
    { import = "mods.vcs" },
    { import = "mods.debug" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "reham_mist" } },
  checker = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Boot layer: apply options, keymaps and autocmds after lazy.nvim / LazyVim
-- have applied their defaults, so our custom values win.
require("boot.opts")
require("boot.keys")
require("boot.events")
require("boot.bugdelta")
