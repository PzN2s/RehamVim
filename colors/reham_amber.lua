-- reham_amber: retro amber & olive glow on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0a0805",
  bg_mid     = "#100d08",
  bg_raised  = "#16120b",
  border     = "#262113",
  border_hi  = "#392f1a",
  grey       = "#82795f",
  grey_soft  = "#a2987c",
  fg_soft    = "#c9bfa3",
  fg         = "#f2e8c8",
  bright     = "#fff6d8",
  accent     = "#e8a24a",
  accent_hi  = "#f5c67c",
  dim        = "#4a3f25",
  error      = "#e07a55",
  warn       = "#dcae58",
  info       = "#d9c58a",
  ok         = "#bfd98a",
  comment    = "#82795f",
  string     = "#b8cc7a",
  number     = "#e8a24a",
  constant   = "#e07a55",
  keyword    = "#e0b070",
  ["function"] = "#d9c58a",
  type       = "#9fb4d9",
  operator   = "#c9bfa3",
  delimiter  = "#8a8070",
  tag        = "#e8a24a",
  property   = "#9fb4d9",
  variable   = "#f2e8c8",
  directory  = "#e8a24a",
  file       = "#f5e8c8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_amber", C)