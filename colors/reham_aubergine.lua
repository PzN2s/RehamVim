-- reham_aubergine: deep eggplant purple with iris & lilac on pure black.
local C = {
  ink        = "#000000",
  bg         = "#000000",
  bg_soft    = "#0a080c",
  bg_mid     = "#110d17",
  bg_raised  = "#181323",
  border     = "#2a2136",
  border_hi  = "#3d314e",
  grey       = "#7a6f8a",
  grey_soft  = "#9c91ac",
  fg_soft    = "#c2b8d1",
  fg         = "#e6def0",
  bright     = "#f7eff9",
  accent     = "#a78be0",
  accent_hi  = "#c4b0ef",
  dim        = "#473d5c",
  error      = "#e07f9c",
  warn       = "#ddb57a",
  info       = "#8fb4d9",
  ok         = "#a0c99a",
  comment    = "#7a6f8a",
  string     = "#a8c9c0",
  number     = "#e0c07d",
  constant   = "#dd7fa0",
  keyword    = "#c79ae0",
  ["function"] = "#a08fe0",
  type       = "#8fb4d9",
  operator   = "#c2b8d1",
  delimiter  = "#837698",
  tag        = "#e0c07d",
  property   = "#a8b8e8",
  variable   = "#e6def0",
  directory  = "#a78be0",
  file       = "#efe7f6",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_aubergine", C)