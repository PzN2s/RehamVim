-- reham_quantum: vivid multicolor palette on pure black, modern-IDE feel.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#070708",
  bg_mid     = "#0c0c0f",
  bg_raised  = "#111114",
  border     = "#1c1c22",
  border_hi  = "#2a2a34",
  grey       = "#585868",
  grey_soft  = "#7a7a8a",
  fg_soft    = "#a9a9b3",
  fg         = "#e2e2e6",
  bright     = "#ffffff",
  accent     = "#61afef",
  accent_hi  = "#9cc4f2",
  dim        = "#31313b",
  error      = "#e0556d",
  warn       = "#e5c07b",
  info       = "#61afef",
  ok         = "#98c379",
  comment    = "#585868",
  string     = "#98c379",
  number     = "#d7ba7d",
  constant   = "#d19a66",
  keyword    = "#c678dd",
  ["function"] = "#61afef",
  type       = "#56b6c2",
  operator   = "#56b6c2",
  delimiter  = "#67677a",
  tag        = "#d7ba7d",
  property   = "#61afef",
  variable   = "#e2e2e6",
  directory  = "#61afef",
  file       = "#c8ccd4",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_quantum", C)