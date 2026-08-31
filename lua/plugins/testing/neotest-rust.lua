---@type LazySpec
-- NOTE: Neotest configuration for Rust

return {
  "nvim-neotest/neotest",
  optional = true,
  opts = {
    adapters = {
      ["rustaceanvim.neotest"] = {},
    },
  },
}
