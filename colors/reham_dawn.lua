-- reham_dawn: warm midnight-coffee palette. Soft sepia on deep warm brown,
-- with a molasses-amber accent — cozy for long sessions in low light.
local C = {
  ink        = "#0d0a07",
  bg         = "#12100c",
  bg_soft    = "#18150f",
  bg_mid     = "#201c14",
  bg_raised  = "#282319",
  border     = "#353026",
  border_hi  = "#463f32",
  grey       = "#8a8174",
  grey_soft  = "#a3998a",
  fg_soft    = "#c0b6a6",
  fg         = "#e9e0d0",
  bright     = "#f9f4ea",
  accent     = "#d9a96b",
  accent_hi  = "#f0c98f",
  dim        = "#544c40",
  error      = "#e07f6d",
  warn       = "#d9b46a",
  info       = "#9aa8c0",
  ok         = "#a9b88e",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_dawn", C)