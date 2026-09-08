-- reham_ocean: deep navy depth with soft sky accents. Cool and focused,
-- ideal for long stretches of dense code.
local C = {
  ink        = "#060a10",
  bg         = "#0a1018",
  bg_soft    = "#0f1620",
  bg_mid     = "#151e2b",
  bg_raised  = "#1b2634",
  border     = "#253444",
  border_hi  = "#33475c",
  grey       = "#7f8fa3",
  grey_soft  = "#97a7ba",
  fg_soft    = "#b6c4d4",
  fg         = "#dde7f0",
  bright     = "#f2f8ff",
  accent     = "#6bb3d9",
  accent_hi  = "#a3d8f2",
  dim        = "#46566a",
  error      = "#e08a92",
  warn       = "#d9bc7a",
  info       = "#79b8d9",
  ok         = "#82c0a0",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_ocean", C)