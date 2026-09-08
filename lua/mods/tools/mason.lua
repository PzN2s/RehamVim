---@type LazySpec
-- NOTE: Mason is configured by LazyVim's LSP module. Only non-LSP tools
-- belong here: LSP servers are auto-installed by LazyVim through the
-- `lspconfig.servers` table (their opts live in mods/langs/*). Listing a
-- server in BOTH places makes mason and mason-lspconfig race to install the
-- same package ("Package is already installing").
--
-- We replace LazyVim's `config` with a guarded install loop: a package is
-- only installed when it is BOTH not installed and not currently being
-- installed, and every install is pcall-guarded. This makes the "Package is
-- already installing" assert (mason-core/package/init.lua:124) unreachable
-- no matter which path starts the install first.

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "codelldb",
        "markdown-toc",
        "marksman",
        "shellcheck",
        "tree-sitter-cli",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() and not p:is_installing() then
            pcall(function()
              p:install()
            end)
          end
        end
      end)
    end,
  },
}