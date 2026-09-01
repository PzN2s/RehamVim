---@type LazySpec
-- NOTE: Which-key configuration

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>t", group = "terminal" }, -- Labels your new terminal group
        { "<leader>T", group = "test" }, -- Labels your new terminal group
        { "<leader>P", group = "plugins" },
      },
    },
  },
}
