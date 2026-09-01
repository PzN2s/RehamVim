local M = {}

-- Profile detection patterns: path substring -> profile name
local AUTO_PROFILES = {
  { pattern = "/work/",      profile = "work" },
  { pattern = "/bugbounty/", profile = "bugbounty" },
  { pattern = "/writing/",   profile = "writing" },
  { pattern = "/ctf/",       profile = "bugbounty" },
  { pattern = "/hacking/",   profile = "bugbounty" },
  { pattern = "/docs/",      profile = "writing" },
  { pattern = "/blog/",      profile = "writing" },
  { pattern = "/notes/",     profile = "writing" },
}

local override_file = ".nvim-profile"
local state = {
  current = nil,
  source = nil, -- "auto" | "override" | "manual"
}

local function read_override(root)
  local path = root .. "/" .. override_file
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    if #lines > 0 then
      local p = vim.trim(lines[1]):lower()
      if p ~= "" then return p end
    end
  end
  return nil
end

local function auto_detect(cwd)
  for _, entry in ipairs(AUTO_PROFILES) do
    if cwd:find(entry.pattern, 1, true) then
      return entry.profile
    end
  end
  return nil
end

function M.resolve(cwd)
  cwd = cwd or vim.fn.getcwd()
  local override = read_override(cwd)
  if override then
    return override, "override"
  end
  local auto = auto_detect(cwd)
  if auto then
    return auto, "auto"
  end
  return "default", "fallback"
end

function M.refresh()
  local cwd = vim.fn.getcwd()
  local profile, source = M.resolve(cwd)
  if profile ~= state.current then
    state.current = profile
    state.source = source
    vim.g.active_profile = profile
    vim.g.active_profile_source = source
    local msg = string.format("Profile: %s (%s)", profile, source)
    vim.notify(msg, vim.log.levels.INFO, { title = "RehamVim Profile" })
  end
  return profile
end

function M.set_manual(profile)
  state.current = profile
  state.source = "manual"
  vim.g.active_profile = profile
  vim.g.active_profile_source = "manual"
  vim.notify("Profile manually set: " .. profile, vim.log.levels.INFO, { title = "RehamVim Profile" })
end

function M.get()
  if not state.current then
    M.refresh()
  end
  return state.current
end

function M.get_source()
  if not state.current then
    M.refresh()
  end
  return state.source
end

M.is_work = function() return M.get() == "work" end
M.is_bugbounty = function() return M.get() == "bugbounty" end
M.is_writing = function() return M.get() == "writing" end
M.is_default = function() return M.get() == "default" end

function M.available()
  return { "work", "bugbounty", "writing", "default" }
end

return M