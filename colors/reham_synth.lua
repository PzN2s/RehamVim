-- reham_synth: retro synthwave neon on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#120011",
  bg_mid     = "#1a0018",
  bg_raised  = "#220020",
  border     = "#36062f",
  border_hi  = "#4a1240",
  grey       = "#8a6f96",
  grey_soft  = "#a589a8",
  fg_soft    = "#c9b8dc",
  fg         = "#e8def2",
  bright     = "#fbf4ff",
  accent     = "#ff6ec7",
  accent_hi  = "#ffa2d8",
  dim        = "#52304e",
  error      = "#ff5c7a",
  warn       = "#ffd866",
  info       = "#00f0ff",
  ok         = "#74ffc4",
  comment    = "#8a6f96",
  string     = "#26d0c4",
  number     = "#ffd866",
  constant   = "#f97e72",
  keyword    = "#ff6ec7",
  ["function"] = "#00f0ff",
  type       = "#c792e8",
  operator   = "#ff6ec7",
  delimiter  = "#9a7fa8",
  tag        = "#ffd866",
  property   = "#00f0ff",
  variable   = "#e8def2",
  directory  = "#ff6ec7",
  file       = "#f2e2fa",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_synth", C)