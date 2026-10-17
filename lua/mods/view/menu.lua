---@type LazySpec
-- NOTE: VS Code-style right-click context menu
return {
  { "nvzone/volt", lazy = true },
  {
    "nvzone/menu",
    lazy = true,
    cmd = { "OpenSmartMenu" },
    config = function()
      local menu = require("menu")

      vim.api.nvim_create_user_command("OpenSmartMenu", function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype

        if ft == "NvimTree" then
          menu.open("nvimtree", { mouse = true })
        else
          menu.open(require("lib.menu_coder"), { mouse = true })
        end
      end, {})
    end,
  },
}
