-- reham_peach: warm apricot & peach on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#100a06",
  bg_mid     = "#170f09",
  bg_raised  = "#1f150d",
  border     = "#36281a",
  border_hi  = "#4a3a26",
  grey       = "#8d7a62",
  grey_soft  = "#a8967c",
  fg_soft    = "#cfbfa4",
  fg         = "#efdfc8",
  bright     = "#fdf5e8",
  accent     = "#f0a868",
  accent_hi  = "#f7c48d",
  dim        = "#58442c",
  error      = "#e07a6a",
  warn       = "#e0c078",
  info       = "#9ab0d9",
  ok         = "#b8c99a",
  comment    = "#8d7a62",
  string     = "#c9d98a",
  number     = "#d9b070",
  constant   = "#e08a6a",
  keyword    = "#c0a8d9",
  ["function"] = "#a0b8d9",
  type       = "#a8c0c9",
  operator   = "#c9baa0",
  delimiter  = "#977f66",
  tag        = "#e0a868",
  property   = "#a8b8d9",
  variable   = "#efdfc8",
  directory  = "#f0a868",
  file       = "#f7e9d2",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_peach", C)