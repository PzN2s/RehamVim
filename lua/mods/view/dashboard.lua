pcall(vim.fn.writefile, { "DASHBOARD-SPEC-LOADED" }, "/tmp/dspec_probe")
return {
  {
    "folke/snacks.nvim",
    enabled = true,
    ---@diagnostic disable-next-line: assign-type-mismatch
    opts = function()
      -- Single source of truth lives in lib.dashboard_cfg (icons via
      -- nr2char there, so no PUA bytes ever live in spec files).
      -- boot/events.lua re-applies it at VimEnter and repaints, so the
      -- first paint and every later open always match.
      -- NOTE: must stay nested under the `dashboard` key, like every
      -- snacks spec: flat keys would be read as other modules' configs.
      return { dashboard = require("lib.dashboard_cfg") }
    end,
  },
}
