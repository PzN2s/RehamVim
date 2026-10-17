-- reham_violet: deep violet night on near-black plum. Purple leads the syntax,
-- with mint and blue accents so code stays readable instead of monochrome.
local C = {
  ink = "#07060c",
  bg = "#0b0a12",
  bg_soft = "#131020",
  bg_mid = "#191528",
  bg_raised = "#201a34",
  border = "#2b2442",
  border_hi = "#4a3d6e",
  grey = "#746a90",
  grey_soft = "#8f85ab",
  fg_soft = "#b5adcb",
  fg = "#d8d1e8",
  bright = "#f1edfb",
  accent = "#b79cf0",
  accent_hi = "#d4c1ff",
  dim = "#392f57",
  error = "#e08a9c",
  warn = "#d9b97c",
  info = "#8fb6e8",
  ok = "#85c9a6",
  comment = "#746a90",
  string = "#c8a6e8",
  number = "#d9b97c",
  constant = "#a79bec",
  keyword = "#c79ce8",
  ["function"] = "#9cc3f0",
  type = "#86cdbe",
  operator = "#b79cf0",
  delimiter = "#746a90",
  tag = "#e0a3d2",
  property = "#c3b7e3",
  variable = "#b5adcb",
  directory = "#8fb6e8",
  file = "#d8d1e8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_violet", C)
