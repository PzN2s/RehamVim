local C = {
  ink = "#0A0A0A",
  bg = "#0A0A0A",
  bg_soft = "#141214",
  bg_mid = "#1A171C",
  bg_raised = "#211D26",
  border = "#211D26",
  border_hi = "#5A545E",
  grey = "#7A6F78",
  grey_soft = "#9A8F98",
  fg_soft = "#B8AEB5",
  fg = "#DCD2D6",
  bright = "#F5F0F2",
  accent = "#C08A94",
  accent_hi = "#D9AAB4",
  dim = "#5A545E",
  error = "#B45F6A",
  warn = "#C9A86A",
  info = "#9DB89A",
  ok = "#8AA37A",
  comment = "#7A6F78",
  string = "#C79A76",
  number = "#C9A86A",
  constant = "#C9A86A",
  keyword = "#C08A94",
  ["function"] = "#E3D3AC",
  type = "#A9C0A4",
  operator = "#C08A94",
  delimiter = "#7A6F78",
  tag = "#C08A94",
  property = "#DCD2D6",
  variable = "#B8AEB5",
  directory = "#C9A86A",
  file = "#DCD2D6",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_rose", C)
