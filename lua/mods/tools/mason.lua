---@type LazySpec
-- NOTE: Mason is configured by LazyVim's LSP module. Only non-LSP tools
-- belong here: LSP servers are auto-installed by LazyVim through the
-- `lspconfig.servers` table (their opts live in mods/langs/*). Listing a
-- server in BOTH places makes mason and mason-lspconfig race to install the
-- same package ("Package is already installing").

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "markdown-toc",
        "marksman",
        "shellcheck",
        "tree-sitter-cli",
      },
    },
  },
}