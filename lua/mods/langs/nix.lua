---@type LazySpec
-- NOTE: Nix language support

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = { enabled = false },
        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
      },
    },
  },
}
