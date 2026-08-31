---@type LazySpec
-- NOTE: Discord Rich Presence

return {
  "vyfor/cord.nvim",
  event = "VeryLazy",
  build = ":Cord update",
  opts = {
    usercmds = true,
    editor = {
      client = "neovim",
      tooltip = "RehamVim - The Superior Text Editor",
    },
    display = {
      theme = "catppuccin",
      flavor = "accent",
      show_time = true,
      show_repository = true,
    },
    buttons = {
      {
        label = "Website",
        url = "https://reham-anz.pages.dev/",
      },
      {
        label = "GitHub",
        url = "https://github.com/PzN2s",
      },
    },
  },
}
