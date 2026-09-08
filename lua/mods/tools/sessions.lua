return {
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<leader>qX",
        function()
          require("persistence").select()
        end,
        desc = "List Sessions",
      },
    },
  },
}