return {
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    enabled = true,
    ---@diagnostic disable-next-line: assign-type-mismatch
    opts = function()
      local function getHeader()
        local headers = {
          [[
  ████ ██████           █████      ██    RehamVim.
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
          ]],
          [[
 ██╗ ██╗     ██╗   ██╗██╗███╗   ███╗   
████████╗    ██║   ██║██║████╗ ████║   
╚██╔═██╔╝    ██║   ██║██║██╔████╔██║   
████████╗    ╚██╗ ██╔╝██║██║╚██╔╝██║   
╚██╔═██╔╝     ╚████╔╝ ██║██║ ╚═╝ ██║██╗
 ╚═╝ ╚═╝       ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝
          ]],
          [[
█████      ██   RehamVim.
       █████                            
        ████████ ███   ███████████  
         ████████ █████ ██████████████  
          ███████ █████ █████ ████ █████  
           ██████ █████ █████ ████ █████ 
            ████ █████ █████ ████ ██████
          ]],
        }

        local idx = vim.g.dashboard_header_idx or math.random(1, #headers)
        vim.g.dashboard_header_idx = (idx % #headers) + 1
        return headers[idx]
      end

      local header_cmd
      local is_windows = vim.fn.has("win32") == 1

      if is_windows then
        -- Windows version using PowerShell
        header_cmd =
          [[powershell.exe -NoProfile -Command "Write-Host ('$([char]27)[31m ▀ █ █ ▀ $([char]27)[0m $([char]27)[32m ▀ █ █ ▀ $([char]27)[0m $([char]27)[33m ▀ █ █ ▀ $([char]27)[0m $([char]27)[34m ▀ █ █ ▀ $([char]27)[0m $([char]27)[35m ▀ █ █ ▀ $([char]27)[0m $([char]27)[36m ▀ █ █ ▀ $([char]27)[0m'); Write-Host ('$([char]27)[31m ██   ██ $([char]27)[0m $([char]27)[32m ██   ██ $([char]27)[0m $([char]27)[33m ██   ██ $([char]27)[0m $([char]27)[34m ██   ██ $([char]27)[0m $([char]27)[35m ██   ██ $([char]27)[0m $([char]27)[36m ██   ██ $([char]27)[0m'); Write-Host ('$([char]27)[31m ▄ █ █ ▄ $([char]27)[0m $([char]27)[32m ▄ █ █ ▄ $([char]27)[0m $([char]27)[33m ▄ █ █ ▄ $([char]27)[0m $([char]27)[34m ▄ █ █ ▄ $([char]27)[0m $([char]27)[35m ▄ █ █ ▄ $([char]27)[0m $([char]27)[36m ▄ █ █ ▄ $([char]27)[0m')"]]
      else
        -- Linux/macOS version using printf
        header_cmd =
          [[printf "\033[31m ▀ █ █ ▀ \033[0m \033[32m ▀ █ █ ▀ \033[0m \033[33m ▀ █ █ ▀ \033[0m \033[34m ▀ █ █ ▀ \033[0m \033[35m ▀ █ █ ▀ \033[0m \033[36m ▀ █ █ ▀ \033[0m\n\033[31m ██   ██ \033[0m \033[32m ██   ██ \033[0m \033[33m ██   ██ \033[0m \033[34m ██   ██ \033[0m \033[35m ██   ██ \033[0m \033[36m ██   ██ \033[0m\n\033[31m ▄ █ █ ▄ \033[0m \033[32m ▄ █ █ ▄ \033[0m \033[33m ▄ █ █ ▄ \033[0m \033[34m ▄ █ █ ▄ \033[0m \033[35m ▄ █ █ ▄ \033[0m \033[36m ▄ █ █ ▄ \033[0m\n"]]
      end
      -- Then set your dashboard command to

      return {
        ---@class snacks.dashboard.Config
        dashboard = {
          enabled = true,
          width = 60,
          row = nil,
          col = nil,
          pane_gap = 4,
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
          preset = {
            pick = nil,
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = getHeader(),
          },

          formats = {
            icon = function(item)
              if item.file and item.icon == "file" or item.icon == "directory" then
                return Snacks.dashboard.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = "icon" }
            end,
            footer = { "%s", align = "center" },
            header = { "%s", align = "center" },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ":~")
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ":h")
                local file = vim.fn.fnamemodify(fname, ":t")
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. "/…" .. file
                end
              end
              local dir, file = fname:match("^(.*)/(.+)$")
              return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
            end,
          },
          sections = {
            { section = "header" },
            {
              pane = 2,
              section = "terminal",
              cmd = header_cmd,
              height = 9,
              align = "center",
              padding = 1,
            },
            { section = "keys", gap = 1, padding = 1 },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = false,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
          },
        },
      }
    end,
  },
}
