---@type LazySpec
-- NOTE: Copilot LSP - required by sidekick.nvim for NES
return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Enable Copilot LSP via Neovim's built-in vim.lsp.enable (neovim >= 0.11)
      vim.lsp.enable("copilot")
    end,
  },
}
