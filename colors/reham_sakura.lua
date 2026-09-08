-- reham_sakura: cherry-blossom pinks and lilac on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0b0809",
  bg_mid     = "#120e10",
  bg_raised  = "#1a1215",
  border     = "#2a1f23",
  border_hi  = "#3b2a30",
  grey       = "#7a6b72",
  grey_soft  = "#9a8a92",
  fg_soft    = "#c4b2ba",
  fg         = "#f0dfe4",
  bright     = "#fdf0f3",
  accent     = "#e59ab0",
  accent_hi  = "#f7b7c8",
  dim        = "#46303a",
  error      = "#e87a90",
  warn       = "#e0b878",
  info       = "#b8a0d9",
  ok         = "#b5c99a",
  comment    = "#7a6b72",
  string     = "#b5c99a",
  number     = "#e0c07d",
  constant   = "#e0a86b",
  keyword    = "#d79cb8",
  ["function"] = "#b8a0d9",
  type       = "#9ab8c9",
  operator   = "#c4b2ba",
  delimiter  = "#8a7480",
  tag        = "#e0c07d",
  property   = "#a0c9c9",
  variable   = "#f0dfe4",
  directory  = "#b8a0d9",
  file       = "#f0e2e8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_sakura", C)