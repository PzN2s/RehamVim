-- reham_ink: editorial white-forward palette on pure black, gold accents.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#090909",
  bg_mid     = "#0e0e10",
  bg_raised  = "#131316",
  border     = "#1f1f24",
  border_hi  = "#2d2d36",
  grey       = "#6a6a74",
  grey_soft  = "#8c8c96",
  fg_soft    = "#b8b8c0",
  fg         = "#f0f0f2",
  bright     = "#ffffff",
  accent     = "#e0c07d",
  accent_hi  = "#f0daa8",
  dim        = "#3f3f46",
  error      = "#e08090",
  warn       = "#e0b878",
  info       = "#7fb3e8",
  ok         = "#8fd3a5",
  comment    = "#6a6a74",
  string     = "#8fd3a5",
  number     = "#e0c07d",
  constant   = "#e0c07d",
  keyword    = "#c7a8f0",
  ["function"] = "#7fb3e8",
  type       = "#67c8c8",
  operator   = "#b9b9c2",
  delimiter  = "#8b8b95",
  tag        = "#e0c07d",
  property   = "#9cc0e8",
  variable   = "#f0f0f2",
  directory  = "#7fb3e8",
  file       = "#f4f4f6",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_ink", C)