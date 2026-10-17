-- reham_green_plus: faithful Everforest (bg medium, dark) palette.
-- Colors are the official everforest values (sainnhe/everforest); the syntax
-- mapping follows upstream too (keywords red, functions/strings green,
-- numbers purple, constants aqua, types yellow, operators orange,
-- identifiers/properties blue, comments grey).
local C = {
  ink = "#232a2e",
  bg = "#2d353b",
  bg_soft = "#343f44",
  bg_mid = "#3d484d",
  bg_raised = "#3d484d",
  border = "#495156",
  border_hi = "#859289",
  grey = "#859289",
  grey_soft = "#9da9a0",
  fg_soft = "#c0b69c",
  fg = "#d3c6aa",
  bright = "#e6e2cc",
  accent = "#a7c080",
  accent_hi = "#bcd596",
  dim = "#5c6a72",
  error = "#e67e80",
  warn = "#dbbc7f",
  info = "#7fbbb3",
  ok = "#a7c080",
  comment = "#859289",
  string = "#a7c080",
  number = "#d699b6",
  constant = "#83c092",
  keyword = "#e67e80",
  ["function"] = "#a7c080",
  type = "#dbbc7f",
  operator = "#e69875",
  delimiter = "#d3c6aa",
  tag = "#e69875",
  property = "#7fbbb3",
  variable = "#d3c6aa",
  directory = "#a7c080",
  file = "#d3c6aa",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_green_plus", C)
