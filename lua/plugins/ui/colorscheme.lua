---@type LazySpec

local last_file = vim.fn.stdpath("data") .. "/last_colorscheme"
local ok, lines = pcall(vim.fn.readfile, last_file)
local last_colorscheme = ok and #lines > 0 and lines[1]:gsub("%s+", "") or nil

local function valid_colorscheme(name)
  local ok, _ = pcall(vim.cmd.colorscheme, name)
  return ok
end

local default_colorscheme = function()
  if last_colorscheme and valid_colorscheme(last_colorscheme) then
    return last_colorscheme
  end
  return "reham_mist"
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = default_colorscheme(),
    },
  },
  {
    "Ferouk/bearded-nvim",
    name = "bearded",
    lazy = true,
    event = "ColorScheme",
    build = function()
      -- Generate helptags so :h bearded-theme works
      local doc = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "bearded", "doc")
      pcall(vim.cmd, "helptags " .. doc)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      term_colors = true,
      color_overrides = {
        mocha = {
          base = "#05070f",
          mantle = "#05070f",
          crust = "#05070f",
        },
      },
    },
  },
  {
    "uhs-robert/oasis.nvim",
    lazy = true,
  },
  {
    "dasupradyumna/midnight.nvim",
    lazy = true,
  },
}
