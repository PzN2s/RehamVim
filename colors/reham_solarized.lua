-- reham_solarized: Solarized Dark on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#001b22",
  bg_mid     = "#00212b",
  bg_raised  = "#002b36",
  border     = "#04323f",
  border_hi  = "#073a49",
  grey       = "#586e75",
  grey_soft  = "#657b83",
  fg_soft    = "#839496",
  fg         = "#93a1a1",
  bright     = "#eee8d5",
  accent     = "#2aa198",
  accent_hi  = "#6cc6bd",
  dim        = "#2f4b54",
  error      = "#dc322f",
  warn       = "#b58900",
  info       = "#268bd2",
  ok         = "#859900",
  comment    = "#586e75",
  string     = "#2aa198",
  number     = "#d33682",
  constant   = "#b58900",
  keyword    = "#d33682",
  ["function"] = "#6c71c4",
  type       = "#859900",
  operator   = "#93a1a1",
  delimiter  = "#586e75",
  tag        = "#cb4b16",
  property   = "#268bd2",
  variable   = "#93a1a1",
  directory  = "#2aa198",
  file       = "#a2b0ae",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_solarized", C)