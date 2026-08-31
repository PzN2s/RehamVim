local color_cache = { slot = -1, fg = nil, bg = nil }

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
    end,
    opts = function()
      local icons = LazyVim.config.icons

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            { "mode", separator = { left = "┃││", right = "" }, padding = { left = 1, right = 1 } },
          },

          lualine_b = {
            { "branch", icon = "", separator = { right = "" }, padding = { left = 1, right = 1 } },
          },

          lualine_c = {
            LazyVim.lualine.root_dir(),
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            LazyVim.lualine.pretty_path(),

            "%=",
            {
              function()
                local frames = { "󱚝", "󱚟", "󰚩", "󱚡", "󱚣", "󱜙", "󱚥", "", "", "", "✦" }
                local index = math.floor(os.time() / 4) % #frames + 1
                return frames[index]
              end,
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },

              color = function()
                local slot = math.floor(os.time() / 4)
                if slot == color_cache.slot then
                  return { fg = color_cache.fg, bg = color_cache.bg, gui = "bold" }
                end
                color_cache.slot = slot
                local hl_groups = {
                  "DiagnosticInfo",
                  "Constant",
                  "Function",
                  "String",
                  "Statement",
                  "Special",
                  "Keyword",
                  "DiagnosticWarn",
                  "NeoTreeNormal",
                  "Type",
                  "Directory",
                }
                local index = slot % #hl_groups + 1

                local fg_color = Snacks.util.color(hl_groups[index])
                local hl = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal", link = false })
                local bg_color = hl.bg and string.format("#%06x", hl.bg)

                color_cache.fg = fg_color
                color_cache.bg = bg_color
                return {
                  fg = fg_color,
                  bg = bg_color,
                  gui = "bold",
                }
              end,
            },
            "%=",
          },

          lualine_x = {
            {
              function()
                return " "
              end,
              color = function()
                local status = require("sidekick.status").get()
                if status then
                  return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
                end
              end,
              cond = function()
                return require("sidekick.status").get() ~= nil
              end,
            },
            {
              function()
                local status = require("sidekick.status").cli()
                return " " .. (#status > 1 and #status or "")
              end,
              cond = function()
                return #require("sidekick.status").cli() > 0
              end,
              color = { fg = "Special" },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "diff",
              symbols = { added = icons.git.added, modified = icons.git.modified, removed = icons.git.removed },
            },
          },

          lualine_y = {
            { "progress", separator = { left = "" }, padding = { left = 1, right = 1 } },
            { "location", padding = { left = 0, right = 1 } },
          },

          lualine_z = {
            {
              function()
                return " " .. os.date("%H:%M:%S%p")
              end,
              separator = { left = "", right = "││┃" },
              padding = { left = 1, right = 1 },
            },
          },
        },
        extensions = { "neo-tree", "nvim-tree", "lazy", "fzf" },
      }
    end,
  },

  {
    "christopher-francisco/tmux-status.nvim",
    enabled = true,
  },
}
