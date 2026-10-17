---@type LazySpec
return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    keys = {
      {
        "<leader>re",
        function()
          require("refactoring").refactor("Extract")
        end,
        mode = "x",
        desc = "Extract Selection",
      },
      {
        "<leader>rE",
        function()
          require("refactoring").refactor("Extract to File")
        end,
        mode = "x",
        desc = "Extract to File",
      },
    },
    opts = {},
  },
}
