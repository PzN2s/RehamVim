-- reham_forest
local C = {
  ink        = "#0b0f0d",
  bg         = "#0e1311",
  bg_soft    = "#131a17",
  bg_mid     = "#1a231f",
  bg_raised  = "#212c27",
  border     = "#2a3731",
  border_hi  = "#3a4a42",
  grey       = "#7d8a84",
  grey_soft  = "#96a39d",
  fg_soft    = "#b3c0ba",
  fg         = "#dce8e1",
  bright     = "#f3fbf6",
  accent     = "#90bf9e",
  accent_hi  = "#b5dcc1",
  dim        = "#4a5752",
  error      = "#e08674",
  warn       = "#d0ad7a",
  info       = "#86b4b0",
  ok         = "#7fb893",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_forest", C)
