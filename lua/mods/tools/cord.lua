---@type LazySpec
-- NOTE: Discord Rich Presence
-- cord.nvim v2 keys. The old ones were wrong, so they were ignored silently:
--   display.show_time     -> timestamp.enabled
--   display.show_repository -> a text line built from opts.repo_url
-- log_level also defaults to OFF, which hides every cord message (including
-- "please run :Cord update"), so problems looked like nothing happening.

return {
  "vyfor/cord.nvim",
  event = "VeryLazy",
  build = ":Cord update",
  opts = {
    usercmds = true,
    log_level = "info",
    editor = {
      client = "neovim",
      tooltip = "RehamVim - The Superior Text Editor",
    },
    display = {
      theme = "atom",
      flavor = "accent",
      view = "full",
    },
    timestamp = {
      enabled = true,
    },
    text = {
      -- second presence line: the git repo name when there is one.
      workspace = function(opts)
        local repo = opts.repo_url and opts.repo_url:match("([^/]+)$")
        return "In " .. (repo or opts.workspace or "a project")
      end,
      editing = function(opts)
        return "Editing " .. opts.filename
      end,
      viewing = function(opts)
        return "Viewing " .. opts.filename
      end,
    },
    buttons = {
      {
        label = "Website",
        url = "https://reham-anz.pages.dev/",
      },
      {
        label = "GitHub",
        url = "https://github.com/PzN2s",
      },
    },
  },
}
