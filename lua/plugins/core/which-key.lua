---@type LazySpec
-- NOTE: Which-key configuration

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>t", group = "terminal" }, -- Labels your new terminal group
        { "<leader>T", group = "test" }, -- Labels your new terminal group
        { "<leader>o", group = "opencode" }, -- Renames the "o" group to "opencode"
        { "<leader>a", group = "SideKick AI" },
        { "<leader>P", group = "plugins" },
      },
    },
  },
}
