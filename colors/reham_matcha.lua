-- reham_matcha: calm matcha-green on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#080d05",
  bg_mid     = "#0c1407",
  bg_raised  = "#111b0a",
  border     = "#1f3013",
  border_hi  = "#2d4520",
  grey       = "#6b7d58",
  grey_soft  = "#8b9c78",
  fg_soft    = "#b7c5a4",
  fg         = "#dfe8d3",
  bright     = "#f2f8e8",
  accent     = "#96b75c",
  accent_hi  = "#b8d888",
  dim        = "#35472a",
  error      = "#e08078",
  warn       = "#e0c078",
  info       = "#8aa8d9",
  ok         = "#7fc98a",
  comment    = "#6b7d58",
  string     = "#bfd98a",
  number     = "#e0c07d",
  constant   = "#e0a06a",
  keyword    = "#9cb8e0",
  ["function"] = "#72c9b0",
  type       = "#c0c878",
  operator   = "#a8b894",
  delimiter  = "#667a52",
  tag        = "#e0c07d",
  property   = "#9cc0e8",
  variable   = "#dfe8d3",
  directory  = "#96b75c",
  file       = "#eaf0df",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_matcha", C)