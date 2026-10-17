-- Smooth UI motion. Scroll is owned by neoscroll (mods/view/scroll.lua), so
-- mini.animate handles cursor + window resize/open/close only. smear-cursor
-- (LazyVim extra) adds the gliding cursor on top. Both follow the wal theme
-- automatically since they use standard highlight groups.
return {
  {
    "nvim-mini/mini.animate",
    -- DISABLED: animating window open/close left the nvim-tree window
    -- black/empty on toggle. Cursor/resize motion stays with smear-cursor
    -- + neoscroll (no window open/close animation involved there).
    enabled = false,
    opts = function()
      local animate = require("mini.animate")
      return {
        cursor = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        resize = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        open = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        close = {
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        scroll = {
          enable = false,
        },
      }
    end,
  },
}
