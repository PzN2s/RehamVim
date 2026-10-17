-- REST/HTTP client for *.http files (no Postman needed).
return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      { "<leader>Rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
      { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle response" },
    },
    opts = {},
  },
}
