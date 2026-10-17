return {
  "johnseth97/gh-dash.nvim",
  lazy = true,
  keys = {
    {
      "<leader>gu",
      function()
        require("gh_dash").toggle()
      end,
      desc = "Toggle gh-dash popup",
    },
  },
  opts = {
    keymaps = {}, -- disable internal mapping
    border = "rounded", -- or 'double'
    width = 0.8,
    height = 0.8,
    autoinstall = true,
  },
}
