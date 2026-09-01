-- reham_mint: fresh mint & coral on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#05090a",
  bg_mid     = "#090d11",
  bg_raised  = "#0d1219",
  border     = "#172129",
  border_hi  = "#243440",
  grey       = "#5d6b76",
  grey_soft  = "#7f919c",
  fg_soft    = "#b2c0c9",
  fg         = "#dfe8ec",
  bright     = "#f5fafb",
  accent     = "#7dd3c5",
  accent_hi  = "#a9e5da",
  dim        = "#2f3d45",
  error      = "#e58a87",
  warn       = "#e0bc78",
  info       = "#86b7d9",
  ok         = "#8fc9a8",
  comment    = "#5d6b76",
  string     = "#8fd3a0",
  number     = "#e0c07d",
  constant   = "#e0a08a",
  keyword    = "#b8a0d9",
  ["function"] = "#86b7d9",
  type       = "#7dd3c5",
  operator   = "#9fb7c2",
  delimiter  = "#5f6e79",
  tag        = "#e0c07d",
  property   = "#86b7d9",
  variable   = "#dfe8ec",
  directory  = "#7dd3c5",
  file       = "#d5e2e8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_mint", C)