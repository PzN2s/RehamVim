-- reham_obsidian: warm retro palette on pure black, soft embers & teal.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0b0a08",
  bg_mid     = "#100f0c",
  bg_raised  = "#16150f",
  border     = "#232118",
  border_hi  = "#33302a",
  grey       = "#6f6859",
  grey_soft  = "#8d8678",
  fg_soft    = "#b8b1a3",
  fg         = "#e8e3d9",
  bright     = "#faf7f0",
  accent     = "#d9b06c",
  accent_hi  = "#f0ce96",
  dim        = "#3d3829",
  error      = "#e07f70",
  warn       = "#d9b46a",
  info       = "#9ab0c8",
  ok         = "#9ec3a0",
  comment    = "#6f6859",
  string     = "#c3d98a",
  number     = "#e0a86b",
  constant   = "#e0a86b",
  keyword    = "#d9969c",
  ["function"] = "#8fb3d9",
  type       = "#8fc2a8",
  operator   = "#c3b89a",
  delimiter  = "#8a806e",
  tag        = "#d9b06c",
  property   = "#a8c2d9",
  variable   = "#e8e3d9",
  directory  = "#8fb3d9",
  file       = "#efe7d3",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_obsidian", C)