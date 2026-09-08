return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>cw",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.notify("No valid buffer", vim.log.levels.WARN)
            return
          end
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local words = 0
          for _, l in ipairs(lines) do
            for _ in l:gmatch("%S+") do
              words = words + 1
            end
          end
          local minutes = math.max(1, math.floor(words / 200 + 0.5))
          vim.notify(string.format("Words: %d · %d min read", words, minutes), vim.log.levels.INFO)
        end,
        desc = "Count Words",
      },
    },
  },
}