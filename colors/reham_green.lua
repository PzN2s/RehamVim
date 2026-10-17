local C = {
  ink = "#0A0A0A",
  bg = "#0A0A0A",
  bg_soft = "#141214",
  bg_mid = "#1A171C",
  bg_raised = "#211D26",
  border = "#211D26",
  border_hi = "#5A545E",
  grey = "#6F7466",
  grey_soft = "#8E9484",
  fg_soft = "#B3B8A8",
  fg = "#D5D8CC",
  bright = "#F1F3EA",
  accent = "#96A468",
  accent_hi = "#B5C48A",
  dim = "#5A545E",
  error = "#B26E5A",
  warn = "#C6A95E",
  info = "#A8A496",
  ok = "#7C9A5C",
  comment = "#6F7466",
  string = "#BE8A5E",
  number = "#C6A95E",
  constant = "#C6A95E",
  keyword = "#96A468",
  ["function"] = "#DCC88F",
  type = "#7FA38A",
  operator = "#96A468",
  delimiter = "#6F7466",
  tag = "#96A468",
  property = "#D5D8CC",
  variable = "#B3B8A8",
  directory = "#C6A95E",
  file = "#D5D8CC",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_green", C)
