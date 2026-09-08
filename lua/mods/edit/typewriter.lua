return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>uW",
        function()
          require("lib.typewriter").toggle()
        end,
        desc = "Typewriter mode",
      },
    },
  },
}