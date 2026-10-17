-- Minimal programmer home for rehamvim.
-- Single column: big banner, essential keys, short recent files.
-- Applied imperatively AFTER startup (see boot/events.lua): lazy.nvim
-- merges same-plugin opts by table position, so setting Snacks.config
-- directly is deterministic (dashboard.open() reads it live on open).
-- All icons via nr2char(codepoint) so no PUA bytes ever live in this file.
local function I(cp)
  return vim.fn.nr2char(cp)
end

local function header()
  return table.concat({
    [[]],
    [[              __                         _         ]],
    [[   ________  / /_  ____ _____ ___ _   __(_)___ ___ ]],
    [[  / ___/ _ \/ __ \/ __ `/ __ `__ \ | / / / __ `__ \]],
    [[ / /  /  __/ / / / /_/ / / / / / / |/ / / / / / / /]],
    [[/_/   \___/_/ /_/\__,_/_/ /_/ /_/|___/_/_/ /_/ /_/ ]],
    [[]],
  }, "\n")
end

local function footer()
  local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/.cache/wal/wal"))
  local wal = (ok and lines[1] and vim.fn.fnamemodify(lines[1], ":t")) or "?"
  local stats = require("lazy").stats()
  return {
    text = string.format("* %s  ·  %s  ·  %d plugins", vim.g.colors_name or "?", wal, stats.count),
    align = "center",
  }
end

return {
  enabled = true,
  width = 60,
  row = nil,
  col = nil,
  pane_gap = 4,
  autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  preset = {
    pick = nil,
    header = header(),
    keys = {
      { icon = I(0xF07B), key = "e", desc = "Explorer", action = ":NvimTreeToggle" },
      { icon = I(0xF0C5), key = "b", desc = "Buffers", action = ":lua Snacks.dashboard.pick('buffers')" },
      { icon = I(0xF002), key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = I(0xF02D), key = "h", desc = "Help Pages", action = ":lua Snacks.dashboard.pick('help')" },
      { icon = I(0xF0ED), key = "u", desc = "Update Plugins", action = ":Lazy sync" },
      { icon = I(0xF06E), key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = I(0xF011), key = "q", desc = "Quit", action = ":qa" },
    },
  },
  formats = {
    icon = function(item)
      if item.file and item.icon == "file" or item.icon == "directory" then
        return Snacks.dashboard.icon(item.file, item.icon)
      end
      return { item.icon, width = 2, hl = "icon" }
    end,
    footer = { "%s", align = "center" },
    header = { "%s", align = "center" },
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ":~")
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if ctx.width and #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ":h")
        local file = vim.fn.fnamemodify(fname, ":t")
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. "/..." .. file
        end
      end
      local dir, file = fname:match("^(.*)/(.+)$")
      return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
    end,
  },
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "recent_files", gap = 1, padding = 1, limit = 3 },
    function()
      -- Files touched today (distinct from generic recents).
      local day = os.date("%Y-%m-%d")
      local items = { { text = "Today", align = "center" } }
      for _, f in ipairs(vim.v.oldfiles) do
        if #items > 3 then
          break
        end
        local mt = vim.fn.getftime(f)
        if mt > 0 and os.date("%Y-%m-%d", mt) == day and vim.fn.filereadable(f) == 1 then
          items[#items + 1] = { file = f }
        end
      end
      return #items > 1 and items or {}
    end,
    { section = "startup", icon = "" },
    { section = "session" },
  },
}
