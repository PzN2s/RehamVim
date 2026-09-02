return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
    end,
    opts = function()
      local icons = LazyVim.config.icons

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "┃││", right = "" }, padding = { left = 1, right = 1 } },
          },

          lualine_b = {
            { "branch", icon = "", separator = { right = "" }, padding = { left = 1, right = 1 } },
          },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            LazyVim.lualine.pretty_path(),
          },

          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "diff",
              symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
            },
          },

          lualine_y = {
            { "progress", separator = { left = "" }, padding = { left = 1, right = 1 } },
            { "location", padding = { left = 0, right = 1 } },
          },

          lualine_z = {
            {
              function()
                return " " .. os.date("%H:%M:%S%p")
              end,
              separator = { left = "", right = "││┃" },
              padding = { left = 1, right = 1 },
            },
          },
        },
        extensions = { "neo-tree", "nvim-tree", "lazy", "fzf" },
      }
    end,
  },

  {
    "christopher-francisco/tmux-status.nvim",
    enabled = true,
  },
}
