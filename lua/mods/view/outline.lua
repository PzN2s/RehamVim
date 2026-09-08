return {
  {
    "stevearc/aerial.nvim",
    lazy = true,
    keys = {
      { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Outline" },
      { "<leader>cO", "<cmd>AerialNavToggle<cr>", desc = "Outline (Float)" },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown" },
      layout = {
        default_direction = "right",
        min_width = 28,
        max_width = 40,
      },
      keys = {
        ["[g"] = "actions.prev",
        ["]g"] = "actions.next",
        ["[7"] = "actions.prev_up",
        ["]7"] = "actions.next_up",
      },
      show_guides = true,
      post_jump_cmd = "normal! zzv",
      attach_mode = "global",
      close_automatic = true,
    },
  },
}