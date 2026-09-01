-- reham_nord: the popular Nord palette on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#08090b",
  bg_mid     = "#0d0f13",
  bg_raised  = "#12141a",
  border     = "#1e222c",
  border_hi  = "#2e3440",
  grey       = "#4c566a",
  grey_soft  = "#6b7689",
  fg_soft    = "#a7b1c4",
  fg         = "#d8dee9",
  bright     = "#eceff4",
  accent     = "#88c0d0",
  accent_hi  = "#a8d3dd",
  dim        = "#313640",
  error      = "#bf616a",
  warn       = "#d08770",
  info       = "#81a1c1",
  ok         = "#a3be8c",
  comment    = "#4c566a",
  string     = "#a3be8c",
  number     = "#ebcb8b",
  constant   = "#b48ead",
  keyword    = "#81a1c1",
  ["function"] = "#88c0d0",
  type       = "#8fbcbb",
  operator   = "#d8dee9",
  delimiter  = "#5c6678",
  tag        = "#d08770",
  property   = "#81a1c1",
  variable   = "#d8dee9",
  directory  = "#88c0d0",
  file       = "#e5e9f0",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_nord", C)