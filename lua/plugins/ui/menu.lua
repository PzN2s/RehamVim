---@type LazySpec
-- NOTE: VS Code-style right-click context menu
return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu",
    lazy = true,
    config = function()
      local menu = require("menu")

      vim.api.nvim_create_user_command("OpenSmartMenu", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype

        local options = "default"

        if ft == "NvimTree" then
          options = "nvimtree"
        end

        menu.open(options, { mouse = true })
      end, {})
    end,
  },
}
