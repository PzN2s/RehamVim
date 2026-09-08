---@type LazySpec

local day_theme = "reham_mist"
local night_theme = "reham_obsidian"

-- Auto mode is opt-in. Pressing <leader>uK cycles auto -> day -> night.
-- Manual pickers (<leader>uC, :colorscheme) set vim.g.reham_theme_mode=nil
-- so a manual choice always wins over the clock.

local function env()
  if vim.g.reham_theme_mode ~= "auto" then
    return
  end
  local hour = tonumber(os.date("%H"))
  local theme = hour and hour >= 6 and hour < 18 and day_theme or night_theme
  if vim.g.colors_name ~= theme then
    vim.cmd.colorscheme(theme)
  end
end

local function cycle()
  local order = { "auto", "day", "night" }
  local mode = vim.g.reham_theme_mode or "auto"
  for i, m in ipairs(order) do
    if m == mode then
      vim.g.reham_theme_mode = order[i % #order + 1]
      break
    end
  end
  if vim.g.reham_theme_mode == "auto" then
    env()
  else
    vim.cmd.colorscheme(vim.g.reham_theme_mode == "day" and day_theme or night_theme)
  end
  vim.notify("Theme: " .. vim.g.reham_theme_mode, vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.g.reham_theme_mode == "auto" then
      env()
    end
  end,
})

local id
local function tick()
  if vim.g.reham_theme_mode == "auto" then
    env()
  end
  id = vim.uv.new_timer()
  id:start(30 * 60 * 1000, 30 * 60 * 1000, vim.schedule_wrap(tick))
end
tick()

return {
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>uK", cycle, desc = "Cycle theme mode (auto/day/night)" },
    },
  },
}