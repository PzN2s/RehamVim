-- reham_violet: deep indigo base with soft lavender highlights. Rich but
-- calm, a favorite for comfortable high-contrast dark editing.
local C = {
  ink        = "#0a0910",
  bg         = "#0f0e16",
  bg_soft    = "#15141f",
  bg_mid     = "#1c1a2a",
  bg_raised  = "#242138",
  border     = "#302c47",
  border_hi  = "#3f3a5e",
  grey       = "#827e97",
  grey_soft  = "#9c97b2",
  fg_soft    = "#c0bbd3",
  fg         = "#e3dff0",
  bright     = "#f4f1ff",
  accent     = "#ab9df2",
  accent_hi  = "#c9bdf8",
  dim        = "#4c4766",
  error      = "#e0829a",
  warn       = "#d0b27a",
  info       = "#86a8d9",
  ok         = "#8fc4a8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_violet", C)