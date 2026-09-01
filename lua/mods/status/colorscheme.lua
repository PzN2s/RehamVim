---@type LazySpec

local last_file = vim.fn.stdpath("data") .. "/last_colorscheme"
local ok, lines = pcall(vim.fn.readfile, last_file)
local last_colorscheme = ok and #lines > 0 and lines[1]:gsub("%s+", "") or nil

local function valid_colorscheme(name)
  if not name:match("^reham_") then
    return false
  end
  local ok, _ = pcall(vim.cmd.colorscheme, name)
  return ok
end

local default_colorscheme = function()
  if last_colorscheme and valid_colorscheme(last_colorscheme) then
    return last_colorscheme
  end
  -- Reham family only: never fall back to a third-party theme.
  return "reham_mist"
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = default_colorscheme(),
    },
  },
  -- LazyVim core ships tokyonight + catppuccin as fallback themes.
  -- Reham family only: disable them so they are pruned on sync.
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
  },
}