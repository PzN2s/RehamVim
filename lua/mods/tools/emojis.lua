return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>se",
        function()
          Snacks.picker.icons()
        end,
        desc = "Search Icons and Emojis",
      },
    },
  },
}
