---@type NvPluginSpec
-- NOTE: Better Markdown
return {
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "Avante", "codecompanion", "opencode_output" },
    keys = {
      {
        "<leader>m",
        function()
          if vim.bo.filetype == "markdown" then
            vim.cmd("Markview Toggle")
          else
            vim.notify("Only available in markdown", vim.log.levels.WARN, { title = "Markview" })
          end
        end,
        desc = "Toggle Markview",
      },
    },

    opts = {
      preview = {
        filetypes = { "markdown", "Avante", "codecompanion", "opencode_output" },
        ignore_buftypes = {},
      },
      max_length = 99999,
      experimental = { check_rtp_message = false },
    },
    block_quotes = {
      wrap = false,
    },
    headings = {
      org_indent_wrap = false,
    },
    list_items = {
      wrap = false,
    },
    -- enabled = false,
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
