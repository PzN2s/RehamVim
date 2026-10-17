-- :RehamCheck — run the real sanity checks and show a report.
-- Read-only: it never edits the config or your files. Run it after a pull, or
-- whenever nvim feels off, to know whether anything is actually broken.

local config_dir = vim.fn.stdpath("config")

local M = {}

local function rel(path)
  return (path:gsub("^" .. vim.pesc(config_dir) .. "/", ""))
end

local function dirs(path)
  local out = {}
  for name, kind in vim.fs.dir(path) do
    if kind == "directory" then
      out[name] = true
    end
  end
  return out
end

-- every lua file in the config must parse.
local function parse_check()
  local files = vim.fn.glob(config_dir .. "/lua/**/*.lua", false, true)
  vim.list_extend(files, vim.fn.glob(config_dir .. "/colors/*.lua", false, true))
  local bad = {}
  for _, file in ipairs(files) do
    local chunk, err = loadfile(file)
    if not chunk then
      bad[#bad + 1] = rel(file) .. " — " .. tostring(err)
    end
  end
  return #files, bad
end

-- startup must not print errors.
local function messages_check()
  local bad = {}
  for _, line in ipairs(vim.split(vim.fn.execute("messages"), "\n")) do
    local low = line:lower()
    if low:find("error", 1, true) or low:find("failed", 1, true) then
      bad[#bad + 1] = line
    end
  end
  return bad
end

local function plugin_check()
  local ok, lazycfg = pcall(require, "lazy.core.config")
  if not ok then
    return nil
  end
  local registered, broken = 0, {}
  for name, plugin in pairs(lazycfg.plugins) do
    registered = registered + 1
    if plugin._.enabled ~= false and plugin._.installed == false then
      broken[#broken + 1] = name
    end
  end
  return lazycfg, registered, broken
end

-- a locked plugin with no copy on disk is only a problem while it is enabled.
local function lock_check(lazycfg)
  local ok, lock = pcall(vim.json.decode, table.concat(vim.fn.readfile(config_dir .. "/lazy-lock.json"), "\n"))
  if not ok or type(lock) ~= "table" then
    return { "lazy-lock.json" }, {}
  end
  local data = vim.fn.stdpath("data")
  local installed = vim.tbl_extend("force", dirs(data .. "/lazy"), dirs(data .. "/lazy-rocks"))
  local missing, orphans = {}, {}
  for name in pairs(lock) do
    if not installed[name] then
      local plugin = lazycfg and lazycfg.plugins[name]
      if plugin and plugin._.enabled ~= false then
        missing[#missing + 1] = name
      end
    end
  end
  for name in pairs(installed) do
    if name ~= "lazy.nvim" and not lock[name] then
      orphans[#orphans + 1] = name
    end
  end
  table.sort(missing)
  table.sort(orphans)
  return missing, orphans
end

-- every enabled language server must point at a binary that exists.
local function lsp_check()
  local registry = rawget(vim.lsp, "_enabled_configs") or {}
  local total, bad, nix = 0, {}, 0
  for name in pairs(registry) do
    total = total + 1
    local ok, cfg = pcall(function()
      return vim.lsp.config[name]
    end)
    local cmd = ok and type(cfg) == "table" and cfg.cmd or nil
    if type(cmd) == "table" and type(cmd[1]) == "string" then
      if cmd[1]:find("/nix-profile/", 1, true) then
        nix = nix + 1
      end
      if vim.fn.executable(cmd[1]) ~= 1 then
        bad[#bad + 1] = name .. " → " .. cmd[1]
      end
    end
  end
  table.sort(bad)
  return total, bad, nix
end

local function dup_check()
  local seen, dupes = {}, {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    local key = client.name .. "@" .. tostring(client.config and client.config.root_dir)
    if seen[key] then
      dupes[#dupes + 1] = key
    else
      seen[key] = true
    end
  end
  return dupes
end

-- names come from the source, so a command that stopped being registered shows.
local function command_check()
  local names = {}
  for _, file in ipairs({ "lua/boot/polish.lua", "lua/boot/selfcheck.lua" }) do
    local ok, lines = pcall(vim.fn.readfile, config_dir .. "/" .. file)
    if ok then
      for _, line in ipairs(lines) do
        for name in line:gmatch('nvim_create_user_command%s*%(%s*"([%w_:%-]+)"') do
          names[name] = true
        end
        for name in line:gmatch("nvim_create_user_command%s*%(%s*'([%w_:%-]+)'") do
          names[name] = true
        end
      end
    end
  end
  local missing, total = {}, 0
  for name in pairs(names) do
    total = total + 1
    -- exists() returns 2 for user commands, 1 for builtins and 0 when missing.
    if vim.fn.exists(":" .. name) == 0 then
      missing[#missing + 1] = name
    end
  end
  table.sort(missing)
  return total, missing
end

function M.report()
  local out, problems = {}, 0

  local function head(ok, text, details)
    out[#out + 1] = (ok and "  ok    " or "  FAIL  ") .. text
    for _, line in ipairs(details or {}) do
      out[#out + 1] = "            " .. line
    end
    if not ok then
      problems = problems + 1
    end
  end

  local function info(text)
    out[#out + 1] = "  info  " .. text
  end

  local count, bad = parse_check()
  head(#bad == 0, count .. " lua + colors files parse", bad)

  local msgs = messages_check()
  head(#msgs == 0, "no errors in :messages", msgs)

  local lazycfg, registered, broken = plugin_check()
  if lazycfg then
    head(#broken == 0, registered .. " plugins registered, all installed", broken)
    local missing, orphans = lock_check(lazycfg)
    head(#missing == 0, "every locked plugin has a copy on disk", missing)
    if #orphans > 0 then
      info("installed but not in the lock file: " .. table.concat(orphans, ", "))
    end
  else
    info("lazy.nvim not loaded in this run, plugin checks skipped")
  end

  local servers, bad_bin, nix = lsp_check()
  head(#bad_bin == 0, servers .. " explicitly enabled servers have a runnable command", bad_bin)
  if nix > 0 then
    info(nix .. " of them run from the nix profile instead of mason")
  end

  local attached, bad_attached = 0, {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    attached = attached + 1
    local cmd = client.config and client.config.cmd
    if type(cmd) == "table" and type(cmd[1]) == "string" and vim.fn.executable(cmd[1]) ~= 1 then
      bad_attached[#bad_attached + 1] = client.name .. " → " .. cmd[1]
    end
  end
  table.sort(bad_attached)
  head(#bad_attached == 0, attached .. " language servers running here have a runnable command", bad_attached)

  local dupes = dup_check()
  head(#dupes == 0, "no duplicate language server clients", dupes)

  local themes = vim.fn.getcompletion("reham_", "color")
  head(#themes > 0, #themes .. " reham themes available", themes)

  if package.loaded["boot.polish"] then
    local total, cmd_missing = command_check()
    head(#cmd_missing == 0, total .. " custom commands exist", cmd_missing)
  else
    info("boot.polish not loaded in this run, custom command check skipped")
  end

  info("clipboard provider: " .. (vim.fn.has("clipboard") == 1 and "yes" or "no"))
  if vim.g.colors_name then
    info("current theme: " .. vim.g.colors_name)
  end

  out[#out + 1] = ""
  out[#out + 1] = problems == 0 and "  everything checks out — no problems found"
    or ("  " .. problems .. " problem(s) found, see the FAIL lines above")
  return out, problems
end

vim.api.nvim_create_user_command("RehamCheck", function()
  local lines, problems = M.report()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "rehamvim check — " .. os.date("%Y-%m-%d %H:%M"), "" })
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.notify(
    problems == 0 and "rehamcheck: no problems found" or ("rehamcheck: " .. problems .. " problem(s) found"),
    problems == 0 and vim.log.levels.INFO or vim.log.levels.WARN
  )
end, { desc = "Check the setup and report anything broken" })

return M
