-- reham_paper: warm paper, eye-soft contrast (~8:1, never pure white/black).
-- Same hue family as reham_blue, deepened for readability on paper.
local C = {
  ink = "#ffffff",
  bg = "#f1ede3",
  bg_soft = "#e8e2d3",
  bg_mid = "#ded5c1",
  bg_raised = "#d4c9b1",
  border = "#cec2a8",
  border_hi = "#b3a17e",
  grey = "#8b8171",
  grey_soft = "#6d6656",
  fg_soft = "#5b5446",
  fg = "#3a352c",
  bright = "#241f18",
  accent = "#94692c",
  accent_hi = "#75511f",
  dim = "#cdc2ab",
  error = "#ad5347",
  warn = "#93702b",
  info = "#4e6e8c",
  ok = "#5c7e50",
  comment = "#8b8171",
  string = "#5c7e50",
  number = "#93702b",
  constant = "#94692c",
  keyword = "#9c4f45",
  ["function"] = "#4e6e8c",
  type = "#687f4e",
  operator = "#5b5446",
  delimiter = "#8b8171",
  tag = "#94692c",
  property = "#4e6e8c",
  variable = "#3a352c",
  directory = "#4e6e8c",
  file = "#3a352c",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_paper", C)
