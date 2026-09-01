---@type LazySpec
-- NOTE: Highlight colors within Neovim (hex, rgb, hsl, oklch*, tailwind, etc.)
return {
  "brenoprata10/nvim-highlight-colors",
  lazy = false,
  opts = {
    render = "background",
    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_var_usage = true,
    enable_named_colors = true,
    enable_tailwind = true,
    enable_oklch = true,
    exclude_filetypes = {},
    exclude_buftypes = {},
  },
}
