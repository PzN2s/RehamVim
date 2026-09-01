-- reham_graphite: neutral cool palette on pure black, teal & mint accents.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#08090a",
  bg_mid     = "#0d0f11",
  bg_raised  = "#121417",
  border     = "#1d2025",
  border_hi  = "#2b2f37",
  grey       = "#525a66",
  grey_soft  = "#747c88",
  fg_soft    = "#a5acb6",
  fg         = "#e0e3e7",
  bright     = "#ffffff",
  accent     = "#7fc7c7",
  accent_hi  = "#b0e2dc",
  dim        = "#31353d",
  error      = "#e08a8a",
  warn       = "#e0c075",
  info       = "#7fb3e8",
  ok         = "#a0cc8c",
  comment    = "#525a66",
  string     = "#b5d67e",
  number     = "#e8bf6a",
  constant   = "#e8a06a",
  keyword    = "#c7a1e8",
  ["function"] = "#7fc7d5",
  type       = "#7fd5b5",
  operator   = "#8fa2b5",
  delimiter  = "#5f6773",
  tag        = "#e8bf6a",
  property   = "#7fb3e8",
  variable   = "#e0e3e7",
  directory  = "#7fc7d5",
  file       = "#c9d3dc",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_graphite", C)