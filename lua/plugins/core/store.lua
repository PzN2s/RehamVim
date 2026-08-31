---@type LazySpec

return {
  "alex-popov-tech/store.nvim",
  dependencies = { "OXY2DEV/markview.nvim" },
  opts = {},
  cmd = "Store",
  keys = {
    { "<leader>Ps", ":Store<CR>", desc = "Store", silent = true },
  },
}
