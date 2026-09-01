---@type LazyVimConfig

for _, lhs in ipairs({ "<leader>l", "<leader>L" }) do
  if vim.fn.maparg(vim.keycode(lhs), "n") ~= "" then
    vim.keymap.del("n", lhs)
  end
end

vim.keymap.set("n", "<leader>Pl", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>PL", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })
vim.keymap.set("n", "<leader>Pc", "<cmd>lua LazyVim.news.changelog()<cr>", { desc = "LazyVim Changelog" })
vim.keymap.set("n", "<leader>Pp", function()
  local profile = require("boot.profile")
  local items = profile.available()
  vim.ui.select(items, { prompt = "Select Profile: " }, function(choice)
    if choice then
      profile.set_manual(choice)
    end
  end)
end, { desc = "Switch Profile" })
vim.keymap.set("n", "<leader>Pb", function()
  require("lib.utils").bootstrap_project()
end, { desc = "Bootstrap Project" })

vim.keymap.set("n", "<leader>uC", function()
  local themes = vim.tbl_filter(function(name)
    return name:match("^reham_")
  end, vim.fn.getcompletion("", "color"))
  vim.tbl_sort(themes)
  vim.ui.select(themes, { prompt = "Colorscheme: " }, function(choice)
    if choice then
      vim.cmd.colorscheme(choice)
    end
  end)
end, { desc = "Pick colorscheme" })

vim.keymap.set("n", "<leader>cx", function()
  require("lib.utils").run_code()
end, { desc = "Run Code" })

vim.keymap.set({ "n", "v", "i" }, "<leader>cp", "<cmd>OpenSmartMenu<cr>", {
  desc = "Open context menu",
})

vim.keymap.set({ "n", "v", "i" }, "<RightMouse>", function()
  local mousepos = vim.fn.getmousepos()

  if mousepos.screenrow == 1 then
    return vim.cmd.exec('"normal! \\<RightMouse>"')
  end

  if mousepos.winid == 0 then
    return vim.cmd.exec('"normal! \\<RightMouse>"')
  end

  local buf = vim.api.nvim_win_get_buf(mousepos.winid)
  local ft = vim.bo[buf].filetype

  if ft == "snacks_dashboard" or ft == "alpha" or ft == "dashboard" then
    return vim.cmd.exec('"normal! \\<RightMouse>"')
  end

  local ok_menu, _ = pcall(require, "menu.utils")
  if ok_menu then
    require("menu.utils").delete_old_menus()
  end

  vim.cmd.exec('"normal! \\<RightMouse>"')

  vim.cmd("OpenSmartMenu")
end, { desc = "Right click menu" })
