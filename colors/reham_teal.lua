-- reham_teal: teal-dominant calm on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#04100e",
  bg_mid     = "#071614",
  bg_raised  = "#0a1e1b",
  border     = "#12302c",
  border_hi  = "#1c443d",
  grey       = "#4f6b66",
  grey_soft  = "#6f8b86",
  fg_soft    = "#a8c2bd",
  fg         = "#cbded9",
  bright     = "#eafaf6",
  accent     = "#2eccb5",
  accent_hi  = "#67e2cd",
  dim        = "#27473f",
  error      = "#e07b77",
  warn       = "#e0c078",
  info       = "#54a8d9",
  ok         = "#8fd3a0",
  comment    = "#4f6b66",
  string     = "#9fd9a8",
  number     = "#e0c07d",
  constant   = "#e0a06a",
  keyword    = "#66c4d9",
  ["function"] = "#54a8d9",
  type       = "#4ed9c4",
  operator   = "#9fc4bd",
  delimiter  = "#56726c",
  tag        = "#e0c07d",
  property   = "#54a8d9",
  variable   = "#cbded9",
  directory  = "#2eccb5",
  file       = "#d8e8e4",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_teal", C)