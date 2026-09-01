-- reham_ruby: warm ruby-red dominant on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0f0506",
  bg_mid     = "#170809",
  bg_raised  = "#1f0b0d",
  border     = "#351419",
  border_hi  = "#4a1e24",
  grey       = "#8a6a6e",
  grey_soft  = "#a5898d",
  fg_soft    = "#cfb8bc",
  fg         = "#e9dcde",
  bright     = "#fbf2f3",
  accent     = "#e0556d",
  accent_hi  = "#ef7e92",
  dim        = "#523035",
  error      = "#ff5c6e",
  warn       = "#e0b878",
  info       = "#c4a0e0",
  ok         = "#9ec9a0",
  comment    = "#8a6a6e",
  string     = "#c3b87a",
  number     = "#e0b06a",
  constant   = "#ff8a5c",
  keyword    = "#e06a80",
  ["function"] = "#c4a0e0",
  type       = "#a0c9c9",
  operator   = "#cfb8bc",
  delimiter  = "#9a7c80",
  tag        = "#e0b06a",
  property   = "#d99aa8",
  variable   = "#e9dcde",
  directory  = "#e0556d",
  file       = "#f0e6e8",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_ruby", C)