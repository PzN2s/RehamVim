---@type LazySpec
-- NOTE: Bash language support. Uses the NixOS-native bash-language-server:
-- mason's copy cannot start on NixOS (stub-ld), so `mason = false` keeps
-- mason-lspconfig from managing it. (shellcheck + shfmt: same story,
-- pinned to nix paths via conform.)

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          mason = false,
          cmd = { require("lib.toolpath").bin("bash-language-server"), "start" },
        },
      },
      setup = {
        bashls = function(_, opts)
          vim.lsp.config("bashls", { cmd = opts.cmd })
          vim.lsp.enable("bashls")
          return true
        end,
      },
    },
  },
}
