-- Animated indent scope: the current code block's indent guides light up in
-- the wal accent color while the rest stay dim. Pure decoration, zero cost
-- when idle (snacks renders on scroll/cursor events only).
return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = true,
        priority = 1,
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
      scope = {
        enabled = true,
      },
    },
  },
}
