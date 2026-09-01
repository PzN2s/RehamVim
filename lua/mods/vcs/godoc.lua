local group = vim.api.nvim_create_augroup("Godoc", { clear = true })

return {
  "fredrikaverpil/godoc.nvim",
  version = "*",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate godoc go", -- install/update parsers
      config = function()
        require("nvim-treesitter.parsers").godoc = {
          install_info = {
            url = "https://github.com/fredrikaverpil/tree-sitter-godoc",
            files = { "src/parser.c" },
          },
          filetype = "godoc",
        }

        -- Map godoc filetype to use godoc parser
        vim.treesitter.language.register("godoc", "godoc")

        -- Enable :TSInstall godoc, :TSUpdate godoc
        vim.api.nvim_create_autocmd("User", {
          group = group,
          pattern = "TSUpdate",
          callback = function()
            require("nvim-treesitter.parsers").godoc = parser_config
          end,
        })

        -- Enable godoc filetype for .godoc files (optional)
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          group = group,
          pattern = "*.godoc",
          callback = function()
            vim.bo.filetype = "godoc"
          end,
        })
      end,
    },
  },
  cmd = { "GoDoc" },
  ft = "godoc",
  opts = {
    adapters = {
      {
        name = "go",
        opts = {
          get_syntax_info = function()
            return {
              filetype = "godoc",
              language = "godoc", -- Enable tree-sitter godoc parser
            }
          end,
        },
      },
    },
  },
}
