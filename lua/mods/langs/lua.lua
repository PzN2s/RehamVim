---@type LazySpec
-- NOTE: Lua language support. Uses the NixOS-native lua-language-server:
-- mason's copy is dynamically linked and cannot start on NixOS (stub-ld).
-- The setup hook below applies the nix cmd AND excludes the server from
-- mason-lspconfig's automatic_enable (otherwise it would ALSO start the
-- broken mason copy -> duplicate clients).

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
          cmd = { require("lib.toolpath").bin("lua-language-server") },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
              },
              telemetry = { enable = false },
            },
          },
        },
      },
      setup = {
        lua_ls = function(_, opts)
          vim.lsp.config("lua_ls", { cmd = opts.cmd, settings = opts.settings })
          vim.lsp.enable("lua_ls")
          return true
        end,
      },
    },
  },
}
