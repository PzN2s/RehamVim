-- reham_green_light: faithful Everforest (bg medium, light) palette.
-- Same syntax mapping as the dark variant, using the official light values
-- (sainnhe/everforest): warm paper background, deep olive/slate text.
local C = {
  ink = "#ffffff",
  bg = "#fdf6e3",
  bg_soft = "#f4f0d9",
  bg_mid = "#efebd4",
  bg_raised = "#efebd4",
  border = "#e0dcc7",
  border_hi = "#939f91",
  grey = "#939f91",
  grey_soft = "#829181",
  fg_soft = "#6e7c83",
  fg = "#5c6a72",
  bright = "#3f4a50",
  accent = "#8da101",
  accent_hi = "#6d7c01",
  dim = "#bdc3af",
  error = "#f85552",
  warn = "#dfa000",
  info = "#3a94c5",
  ok = "#8da101",
  comment = "#939f91",
  string = "#8da101",
  number = "#df69ba",
  constant = "#35a77c",
  keyword = "#f85552",
  ["function"] = "#8da101",
  type = "#dfa000",
  operator = "#f57d26",
  delimiter = "#5c6a72",
  tag = "#f57d26",
  property = "#3a94c5",
  variable = "#5c6a72",
  directory = "#8da101",
  file = "#5c6a72",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_green_light", C)
