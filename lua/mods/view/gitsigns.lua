---@type LazySpec
-- NOTE: Git gutter signs + current-line blame.

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      preview_config = {
        border = "rounded",
      },
    },
  },
}
