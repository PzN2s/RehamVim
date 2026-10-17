local C = {
  ink = "#0A0A0A",
  bg = "#0A0A0A",
  bg_soft = "#141214",
  bg_mid = "#1A171C",
  bg_raised = "#211D26",
  border = "#211D26",
  border_hi = "#5A545E",
  grey = "#6E6A75",
  grey_soft = "#8E8A94",
  fg_soft = "#C4C0CB",
  fg = "#D8D4DC",
  bright = "#F2F0F0",
  accent = "#9DB89A",
  accent_hi = "#B8D4B5",
  dim = "#5A545E",
  error = "#C08A8A",
  warn = "#C2A878",
  info = "#8AA8C8",
  ok = "#7FA37C",
  comment = "#6E6A75",
  string = "#C49A85",
  number = "#C2A878",
  constant = "#C2A878",
  keyword = "#9DB89A",
  ["function"] = "#D6C69A",
  type = "#8AA8C8",
  operator = "#9DB89A",
  delimiter = "#6E6A75",
  tag = "#9DB89A",
  property = "#D8D4DC",
  variable = "#C4C0CB",
  directory = "#8AA8C8",
  file = "#D8D4DC",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_sage", C)
