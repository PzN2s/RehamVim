local C = {
  ink = "#0A0A0A",
  bg = "#0A0A0A",
  bg_soft = "#141214",
  bg_mid = "#1A171C",
  bg_raised = "#211D26",
  border = "#211D26",
  border_hi = "#5A545E",
  grey = "#77694F",
  grey_soft = "#998A6E",
  fg_soft = "#C9BCA4",
  fg = "#E0D3B8",
  bright = "#F6EFDD",
  accent = "#D9A441",
  accent_hi = "#F0C778",
  dim = "#5A545E",
  error = "#B26E4E",
  warn = "#D9A441",
  info = "#A89A7C",
  ok = "#8A9A5B",
  comment = "#77694F",
  string = "#C08A5A",
  number = "#E3B34C",
  constant = "#E3B34C",
  keyword = "#D9A441",
  ["function"] = "#F0DDA6",
  type = "#A89A7C",
  operator = "#D9A441",
  delimiter = "#77694F",
  tag = "#D9A441",
  property = "#E0D3B8",
  variable = "#C9BCA4",
  directory = "#E3B34C",
  file = "#E0D3B8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_honey", C)
