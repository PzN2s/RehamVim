-- NOTE: Bug Delta — detects diagnostics (errors/warnings) that your save
-- introduces into the current buffer, compares against the pre-save snapshot,
-- and reports the deltas. Part of the RehamVim "boot" layer (loaded after
-- lazy.setup so commands/autocmds are available from startup).

---@diagnostic disable-next-line: undefined-global
local M = {}

local opts = {
  enabled = true, -- auto analysis on save
  max_lines = 20000, -- skip files larger than this
  report_clean = false, -- show a success toast on every clean save
}

-- When diagnostics arrive asynchronously after a save (LSP re-analysis can lag
-- by 1-3s), poll a few times and only finalize once the diff settles.
local attempts_ms = { 400, 1100, 2200, 3800 }

local auto = true -- runtime toggle (RehamBugDeltaToggle)
local snapshots = {} -- bufnr -> { map = {}, errors = 0, warns = 0 }
local news = {} -- bufnr -> list of newly-introduced diagnostics
local pending = {} -- bufnr -> true while waiting for diagnostics to settle

local EMPTY = { map = {}, errors = 0, warns = 0 }

local group = vim.api.nvim_create_augroup("reham_bugdelta", { clear = true })

local function current_buf()
  return vim.api.nvim_get_current_buf()
end

local function buf_lines(bufnr)
  return vim.api.nvim_buf_line_count(bufnr)
end

local function lsp_attached(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  return #clients > 0
end

local function severity(errors, warns)
  if (errors or 0) > 0 then
    return "error"
  elseif (warns or 0) > 0 then
    return "warn"
  end
  return "info"
end

local function notify(kind, msg)
  local ok, _ = pcall(function()
    Snacks.notify[kind](msg, { title = "Bug Delta" })
  end)
  if not ok then
    vim.notify(msg, kind == "error" and vim.log.levels.WARN or vim.log.levels.INFO, { title = "Bug Delta" })
  end
end

local function diag_key(d)
  return (d.bufnr or 0) .. ":" .. d.lnum .. ":" .. d.col .. ":" .. (d.message or "") .. ":" .. (d.severity or 0)
end

local function snapshot(bufnr)
  local diags = vim.diagnostic.get(bufnr)
  local map, errors, warns = {}, 0, 0
  for _, d in ipairs(diags) do
    map[diag_key(d)] = true
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warns = warns + 1
    end
  end
  return diags, { map = map, errors = errors, warns = warns }
end

local function take_snapshot(bufnr)
  if not auto or not opts.enabled then
    return
  end
  if buf_lines(bufnr) > opts.max_lines then
    return
  end
  _, snapshots[bufnr] = snapshot(bufnr)
end

---Compare the current diagnostics against the snapshot for `bufnr`, update
---global state and report the deltas. Returns true when the diff changed.
---@param opts? {manual?: boolean}
function M.run(bufnr, run_opts)
  bufnr = bufnr or current_buf()
  run_opts = run_opts or {}

  local pre = snapshots[bufnr]
  if not pre then
    -- No reference yet: establish a baseline now so the NEXT save is diffed.
    if not run_opts.manual then
      take_snapshot(bufnr)
    end
    return false
  end

  local diags, cur = snapshot(bufnr)
  local added, new_errors, new_warns = {}, 0, 0
  for _, d in ipairs(diags) do
    if not pre.map[diag_key(d)] then
      added[#added + 1] = d
      if d.severity == vim.diagnostic.severity.ERROR then
        new_errors = new_errors + 1
      elseif d.severity == vim.diagnostic.severity.WARN then
        new_warns = new_warns + 1
      end
    end
  end

  local fixed = math.max(pre.errors + pre.warns - (cur.errors + cur.warns), 0)
  local changed = new_errors > 0 or new_warns > 0 or fixed > 0

  news[bufnr] = added
  vim.g.reham_bugdelta = { errors = new_errors, warns = new_warns, fixed = fixed, time = os.time() }
  snapshots[bufnr] = cur -- advance the baseline so the NEXT save diffs against this state

  if new_errors > 0 or new_warns > 0 then
    local parts = {}
    if new_errors > 0 then
      parts[#parts + 1] = new_errors .. " error" .. (new_errors > 1 and "s" or "")
    end
    if new_warns > 0 then
      parts[#parts + 1] = new_warns .. " warning" .. (new_warns > 1 and "s" or "")
    end
    notify(severity(new_errors, new_warns), "This save introduced " .. table.concat(parts, " and "))
  elseif fixed > 0 then
    notify("info", "Fixed " .. fixed .. " issue" .. (fixed > 1 and "s" or "") .. " — the file is clean now")
  else
    -- Never claim "clean" silently when the file still has outstanding issues.
    local existing = cur.errors + cur.warns
    if existing > 0 then
      notify("info", "No new issues introduced — the file already has " .. existing .. " issue"
        .. (existing > 1 and "s" or ""))
    elseif run_opts.manual or opts.report_clean then
      notify("info", "No new issues introduced by the last changes")
    end
  end

  return changed
end

---Set a baseline without reporting anything, then show the current counts so a
---manual :RehamBugDelta always gives feedback (never silently "does nothing").
function M.inspect(bufnr)
  bufnr = bufnr or current_buf()
  local pre = snapshots[bufnr]
  if not pre then
    -- No baseline yet: diff against empty so `:RehamBugDelta` always reports
    -- whatever issues the file currently has.
    snapshots[bufnr] = vim.deepcopy(EMPTY)
  end
  vim.api.nvim_buf_call(bufnr, function()
    M.run(bufnr, { manual = true })
  end)
end

---After a save, keep polling until the LSP diagnostics settle (or give up),
---then finalize the diff once.
local function schedule_settle(bufnr)
  local tries = 0
  local function try()
    tries = tries + 1
    if not pending[bufnr] then
      return
    end
    local changed = M.run(bufnr)
    if not changed and tries >= #attempts_ms then
      pending[bufnr] = nil
      -- Nothing new AND nothing found: if no diagnostics source is attached,
      -- say so instead of silently doing nothing.
      if not lsp_attached(bufnr) then
        notify("warn", "No diagnostics source found for this buffer — the LSP may not be attached to this filetype")
      end
      return
    end
    if changed then
      pending[bufnr] = nil
      return
    end
    vim.defer_fn(try, attempts_ms[tries])
  end
  pending[bufnr] = true
  vim.defer_fn(try, attempts_ms[1])
end

---All newly-introduced diagnostics for a buffer (used by :RehamBugDeltaList).
function M.new_diagnostics(bufnr)
  bufnr = bufnr or current_buf()
  return news[bufnr] or {}
end

---Toggle auto-analysis on save; returns whether it is enabled now.
function M.toggle()
  auto = not auto
  local bufs = vim.tbl_keys(snapshots)
  for _, b in ipairs(bufs) do
    snapshots[b] = nil
  end
  pending = {}
  vim.g.reham_bugdelta = nil
  notify("info", auto and "Bug Delta enabled: monitoring future saves" or "Bug Delta disabled: saves won't be monitored")
  return auto
end

function M.is_auto()
  return auto and opts.enabled
end

---Self-diagnostic for :RehamBugDeltaHealth.
function M.health()
  local buf = current_buf()
  local ft = vim.bo[buf].filetype
  local clients = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    clients[#clients + 1] = c.name
  end
  local diags = vim.diagnostic.get(buf)
  local errs, warns = 0, 0
  for _, d in ipairs(diags) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errs = errs + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warns = warns + 1
    end
  end
  local has_snapshot = snapshots[buf] ~= nil
  local lines = {
    "Bug Delta · health",
    "  filetype: " .. (ft == "" and '(none)' or ft),
    "  LSP clients: " .. (next(clients) and table.concat(clients, ", ") or "NONE — no diagnostics source"),
    "  diagnostics now: " .. errs .. " error(s), " .. warns .. " warning(s)",
    "  auto monitoring: " .. tostring(M.is_auto()),
    "  snapshot taken: " .. tostring(has_snapshot),
  }
  if ft ~= "lua" then
    lines[#lines + 1] = "  NOTE: buffer is not Lua — Bug Delta only detects issues for filetypes with an attached LSP"
  end
  vim.fn.writefile(lines, "/tmp/reham_bd_health.txt")
  vim.cmd("new /tmp/reham_bd_health.txt")
  vim.api.nvim_set_option_value("modifiable", true, {})
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  vim.api.nvim_set_option_value("modifiable", false, {})
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    -- First save: start from an EMPTY baseline so everything already in the
    -- buffer (errors included) is reported, instead of silently absorbing it.
    if snapshots[args.buf] then
      take_snapshot(args.buf)
    else
      snapshots[args.buf] = vim.deepcopy(EMPTY)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  callback = function(args)
    if not auto or not opts.enabled then
      return
    end
    if snapshots[args.buf] and not pending[args.buf] then
      schedule_settle(args.buf)
    end
  end,
})

vim.api.nvim_create_user_command("RehamBugDelta", function()
  M.inspect()
end, { desc = "Bug Delta: analyze diagnostics introduced by the last save" })

vim.api.nvim_create_user_command("RehamBugDeltaToggle", function()
  M.toggle()
end, { desc = "Bug Delta: toggle automatic save monitoring" })

vim.api.nvim_create_user_command("RehamBugDeltaList", function()
  local buf = vim.api.nvim_get_current_buf()
  local added = M.new_diagnostics(buf)
  -- Fall back to the file's CURRENT errors/warnings when nothing new was
  -- detected yet, so the command always produces a useful list.
  if #added == 0 then
    added = vim.tbl_filter(function(d)
      return d.severity == vim.diagnostic.severity.ERROR or d.severity == vim.diagnostic.severity.WARN
    end, vim.diagnostic.get(buf))
  end
  if #added == 0 then
    notify("info", "This file has no errors or warnings")
    return
  end
  pcall(function()
    vim.diagnostic.setloclist({ title = "Bug Delta · diagnostics" }, added)
    vim.cmd("lopen")
  end)
end, { desc = "Bug Delta: open the list of diagnostics (new/then current)" })

vim.api.nvim_create_user_command("RehamBugDeltaHealth", function()
  M.health()
end, { desc = "Bug Delta: show a self-diagnostic report for the current buffer" })

return M