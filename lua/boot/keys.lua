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
  local active = vim.g.colors_name or ""
  local themes = vim.tbl_filter(function(name)
    return name:match("^reham_")
  end, vim.fn.getcompletion("", "color"))
  table.sort(themes)
  if #themes == 0 then
    return
  end

  local idx = vim.fn.index(themes, active) + 1
  if idx < 1 then
    idx = 1
  end

  local total = #themes
  local winh = math.min(total, 15)
  local maxw = 0
  for _, name in ipairs(themes) do
    maxw = math.max(maxw, #name)
  end
  local width = maxw + 5

  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}
  for _, name in ipairs(themes) do
    lines[#lines + 1] = name
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    width = width,
    height = winh,
    row = math.floor(vim.o.lines / 2 - winh / 2),
    col = math.floor(vim.o.columns / 2 - width / 2),
    border = "rounded",
    title = " Colorscheme ",
    title_pos = "center",
  })
  vim.api.nvim_win_set_option(win, "cursorline", true)
  vim.cmd.stopinsert()

  local ns = vim.api.nvim_create_namespace("reham_theme_picker")
  local marker
  local function render()
    if marker then
      vim.api.nvim_buf_del_extmark(buf, ns, marker)
    end
    marker = vim.api.nvim_buf_set_extmark(buf, ns, idx - 1, 0, {
      virt_text = { { "▸ ", "Special" } },
      virt_text_pos = "inline",
      hl_mode = "combine",
    })
  end

  local function move(delta)
    idx = ((idx - 1 + delta) % total) + 1
    render()
    vim.api.nvim_win_set_cursor(win, { idx, 0 })
  end

  local function close()
    pcall(vim.api.nvim_win_close, win, true)
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end

  local function apply()
    pcall(vim.api.nvim_win_close, win, true)
    vim.cmd.colorscheme(themes[idx])
  end

  local function keyspec(lhs, fn)
    for _, mode in ipairs({ "n", "i" }) do
      vim.keymap.set(mode, lhs, fn, { buffer = buf, nowait = true, silent = true })
    end
  end
  keyspec("<Down>", function() move(1) end)
  keyspec("j", function() move(1) end)
  keyspec("<Up>", function() move(-1) end)
  keyspec("k", function() move(-1) end)
  keyspec("<CR>", function() apply() end)
  keyspec("<Esc>", function() close() end)
  keyspec("q", function() close() end)

  render()
  vim.api.nvim_win_set_cursor(win, { idx, 0 })
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
