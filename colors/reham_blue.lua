-- reham_blue: moonlit night on #0A0A0A. Cold silver-blues and pale mint,
-- calm saturation throughout. Nothing warm except warnings/errors, which
-- keep their meaning without shouting.
local C = {
  ink = "#000000",
  bg = "#0A0A0A",
  bg_soft = "#0d1116",
  bg_mid = "#11161c",
  bg_raised = "#171e25",
  border = "#222b34",
  border_hi = "#343f4b",
  grey = "#67707c",
  grey_soft = "#87909b",
  fg_soft = "#9fabb8",
  fg = "#c9d4e0",
  bright = "#eef3f8",
  accent = "#8fb4d4",
  accent_hi = "#b5d1e9",
  dim = "#2e3640",
  error = "#c0838b",
  warn = "#c2b294",
  info = "#7fb0d8",
  ok = "#86b89a",
  comment = "#67707c",
  string = "#84a496",
  number = "#a8c4d8",
  constant = "#8fb4d4",
  keyword = "#9aa0cc",
  ["function"] = "#7fb0d8",
  type = "#93c4b4",
  operator = "#87909b",
  delimiter = "#67707c",
  tag = "#93a0cf",
  property = "#7d99b5",
  variable = "#c9d4e0",
  directory = "#7fb0d8",
  file = "#dbe3ec",
}

local ok, engine = pcall(require, "colorschemes.reham")
if not ok then
  local source = assert(debug.getinfo(1, "S").source):sub(2)
  local root = vim.fn.fnamemodify(source, ":p:h:h")
  engine = assert(loadfile(root .. "/lua/colorschemes/reham.lua"))()
  package.loaded["colorschemes.reham"] = engine
end

engine.define("reham_blue", C)
