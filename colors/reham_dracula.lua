-- reham_dracula: the classic Dracula palette on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0a0a0d",
  bg_mid     = "#101015",
  bg_raised  = "#16161c",
  border     = "#24242c",
  border_hi  = "#34344a",
  grey       = "#565668",
  grey_soft  = "#7a7a8c",
  fg_soft    = "#abb0bd",
  fg         = "#e6e6ee",
  bright     = "#f8f8f2",
  accent     = "#bd93f9",
  accent_hi  = "#ceb2fb",
  dim        = "#3a3a46",
  error      = "#ff5555",
  warn       = "#f1fa8c",
  info       = "#8be9fd",
  ok         = "#50fa7b",
  comment    = "#565668",
  string     = "#f1fa8c",
  number     = "#bd93f9",
  constant   = "#ffb86c",
  keyword    = "#ff79c6",
  ["function"] = "#50fa7b",
  type       = "#8be9fd",
  operator   = "#f8f8f2",
  delimiter  = "#6d6d85",
  tag        = "#ffb86c",
  property   = "#8be9fd",
  variable   = "#e6e6ee",
  directory  = "#8be9fd",
  file       = "#f8f8f2",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_dracula", C)