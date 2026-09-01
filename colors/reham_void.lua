-- reham_void: pure-black cold palette, classic blue/violet code colors.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#08090c",
  bg_mid     = "#0d0f14",
  bg_raised  = "#12141b",
  border     = "#1d2029",
  border_hi  = "#2c313f",
  grey       = "#4a5264",
  grey_soft  = "#6b7488",
  fg_soft    = "#9aa2b3",
  fg         = "#d4d8e3",
  bright     = "#f5f6fa",
  accent     = "#7aa2f7",
  accent_hi  = "#a7c0ff",
  dim        = "#2f333d",
  error      = "#f7768e",
  warn       = "#e0af68",
  info       = "#7aa2f7",
  ok         = "#9ece6a",
  -- per-syntax colors (varied text/files on black)
  comment    = "#4a5264",
  string     = "#9ece6a",
  number     = "#e0af68",
  constant   = "#ff9e64",
  keyword    = "#bb9af7",
  ["function"] = "#7aa2f7",
  type       = "#2ac3de",
  operator   = "#7aa2f7",
  delimiter  = "#565f89",
  tag        = "#e0af68",
  property   = "#89ddff",
  variable   = "#d4d8e3",
  directory  = "#7aa2f7",
  file       = "#c0caf5",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_void", C)