return {
  {
    "snacks.nvim",
    opts = {
      lazygit = {
        configure = true,
        win = {
          border = "rounded",
          width = 0.9,
          height = 0.9,
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit.open({ cwd = LazyVim.root.get() })
        end,
        desc = "LazyGit (Root Dir)",
      },
      {
        "<leader>gG",
        function()
          Snacks.lazygit.open()
        end,
        desc = "LazyGit (cwd)",
      },
    },
  },
}
