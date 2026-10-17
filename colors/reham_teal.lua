-- reham_teal: deep teal night on blue-black. Cool cyan-teal leads the syntax;
-- warm gold only where it must warn.
local C = {
  ink = "#03080a",
  bg = "#060d10",
  bg_soft = "#0c171b",
  bg_mid = "#111f24",
  bg_raised = "#172a30",
  border = "#1f363c",
  border_hi = "#35606a",
  grey = "#608289",
  grey_soft = "#7c9ba3",
  fg_soft = "#a9c6ca",
  fg = "#d1e4e6",
  bright = "#ecf7f8",
  accent = "#4ec7bf",
  accent_hi = "#7fe2d9",
  dim = "#29454c",
  error = "#e08a7a",
  warn = "#d8c274",
  info = "#5fb8e0",
  ok = "#68cfa0",
  comment = "#608289",
  string = "#8fd2a8",
  number = "#d8c274",
  constant = "#4ec7bf",
  keyword = "#5cc9d8",
  ["function"] = "#6fb8e8",
  type = "#7fdcc2",
  operator = "#4ec7bf",
  delimiter = "#608289",
  tag = "#66d2d2",
  property = "#a8dade",
  variable = "#a9c6ca",
  directory = "#5fb8e0",
  file = "#d1e4e6",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_teal", C)
