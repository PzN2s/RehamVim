return {
  {
    "folke/snacks.nvim",
    enabled = true,
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      persist_mode = true,
      shade_terminals = false,
    },

    keys = {
      { "<leader>td", false },

      -- New terminals
      {
        "<leader>th",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "horizontal",
              display_name = "Horizontal",
            })
            :open()
        end,
        desc = "New Horizontal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "vertical",
              display_name = "Vertical",
            })
            :open()
        end,
        desc = "New Vertical",
      },

      -- Toggle
      {
        "<leader>tH",
        "<cmd>ToggleTerm direction=horizontal<CR>",
        desc = "Toggle Horizontal",
      },
      {
        "<leader>tV",
        "<cmd>ToggleTerm direction=vertical<CR>",
        desc = "Toggle Vertical",
      },

      -- Instance picker
      {
        "<leader>tt",
        "<cmd>TermSelect<CR>",
        desc = "Terminal List",
      },

      -- Kill focused
      {
        "<leader>tk",
        function()
          local ok, Terminal = pcall(require, "toggleterm.terminal")
          if not ok then
            return
          end

          local id = vim.b.toggle_number
          if not id then
            vim.notify("Not inside a ToggleTerm", vim.log.levels.WARN)
            return
          end

          local term = Terminal.get(id)
          if term then
            term:shutdown()
          end
        end,
        desc = "Kill Terminal",
      },
    },

    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Double Esc -> Normal mode
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
        desc = "Terminal Normal Mode",
        silent = true,
      })
    end,
  },
}
