return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      git_cmd = { "git" },
      view = {
        default = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        width = 40,
        win_config = { position = "bottom" },
      },
    },
  },
}