---@type LazySpec

local last_file = vim.fn.stdpath("data") .. "/last_colorscheme"
local ok, lines = pcall(vim.fn.readfile, last_file)
local last_colorscheme = ok and #lines > 0 and lines[1]:gsub("%s+", "") or nil

-- Reham family only: keep non-Reham themes out of every Lua-side picker.
-- Neovim's runtime always ships built-in themes that cannot be removed from
-- the installed package, so filter them out at the completion source.
local orig_getcompletion = vim.fn.getcompletion
vim.fn.getcompletion = function(arglead, cmdline)
  if cmdline == "color" then
    return vim.tbl_filter(function(name)
      return name:match("^reham_")
    end, orig_getcompletion(arglead, cmdline))
  end
  return orig_getcompletion(arglead, cmdline)
end

-- snacks' "colorschemes" picker has live preview (it applies the hovered
-- theme) and its source scans `colors/*` on the runtimepath directly, so the
-- getcompletion filter above does not cover it. Patch the loaded source module
-- (require caches it, so this takes effect for later picker opens).
local ok_vim_src, vim_src = pcall(require, "snacks.picker.source.vim")
if ok_vim_src and vim_src and vim_src.colorschemes then
  local orig = vim_src.colorschemes
  vim_src.colorschemes = function()
    local items = orig()
    return vim.tbl_filter(function(item)
      return item.text:match("^reham_")
    end, items)
  end
end

local function valid_colorscheme(name)
  if not name:match("^reham_") then
    return false
  end
  -- File-existence check instead of `vim.cmd.colorscheme`: applying the theme
  -- during spec load re-source it a second time once LazyVim applies it.
  return vim.fn.globpath(vim.o.runtimepath, "colors/" .. name .. ".lua") ~= ""
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