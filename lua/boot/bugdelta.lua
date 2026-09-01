-- NOTE: Bug Delta — detects diagnostics (errors/warnings) that your save
-- introduces into the current buffer, compares against the pre-save snapshot,
-- and reports the deltas. Part of the RehamVim "boot" layer (loaded after
-- lazy.setup so commands/autocmds are available from startup).

---@diagnostic disable-next-line: undefined-global
local M = {}

local opts = {
  enabled = true, -- auto analysis on save
  delay = 400, -- ms to wait for the LSP to settle after a write
  max_lines = 20000, -- skip files larger than this
  report_clean = false, -- show a success toast on every clean save
}

local auto = true -- runtime toggle (RehamBugDeltaToggle)
local snapshots = {} -- bufnr -> { map = {}, errors = 0, warns = 0 }
local news = {} -- bufnr -> list of newly-introduced diagnostics

local group = vim.api.nvim_create_augroup("reham_bugdelta", { clear = true })

local function current_buf()
  return vim.api.nvim_get_current_buf()
end

local function buf_lines(bufnr)
  return vim.api.nvim_buf_line_count(bufnr)
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
---global state and return the newly introduced (and fixed) counts.
function M.run(bufnr)
  bufnr = bufnr or current_buf()
  local pre = snapshots[bufnr]
  if not pre then
    -- No reference yet: establish a baseline now so the NEXT save is diffed.
    take_snapshot(bufnr)
    if not auto or not opts.enabled then
      return
    end
    return
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

  news[bufnr] = added
  vim.g.reham_bugdelta = { errors = new_errors, warns = new_warns, fixed = fixed, time = os.time() }
  snapshots[bufnr] = cur -- advance the baseline so the NEXT save diffs against this state

  if new_errors > 0 or new_warns > 0 then
    local parts = {}
    if new_errors > 0 then
      parts[#parts + 1] = new_errors .. " أخطاء"
    end
    if new_warns > 0 then
      parts[#parts + 1] = new_warns .. " تحذيرات"
    end
    notify(severity(new_errors, new_warns), "هذا الحفظ أضاف " .. table.concat(parts, " و") .. " جديدة")
  elseif fixed > 0 then
    notify("info", "أصلحت " .. fixed .. " مشكلة — الملف نظيف الآن")
    if opts.report_clean then
      notify("info", "بدون أخطاء جديدة استلام")
    end
  elseif opts.report_clean then
    notify("info", "حفظ نظيف، لا شيء جديد")
  end
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
  vim.g.reham_bugdelta = nil
  notify("info", auto and "تفعيل Bug Delta: سأراقب الحفظات القادمة" or "تعطيل Bug Delta: لن أراقب الحفظات")
  return auto
end

---Manual analysis of the current buffer (needs a snapshot from a previous save).
function M.inspect(bufnr)
  local b = bufnr or current_buf()
  vim.api.nvim_buf_call(b, function()
    M.run(b)
  end)
end

function M.is_auto()
  return auto and opts.enabled
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    take_snapshot(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  callback = function(args)
    if not auto or not opts.enabled then
      return
    end
    if snapshots[args.buf] then
      local bufnr = args.buf
      vim.defer_fn(function()
        M.run(bufnr)
      end, opts.delay)
    end
  end,
})

vim.api.nvim_create_user_command("RehamBugDelta", function()
  M.inspect()
end, { desc = "Bug Delta: تحليل تشخيصات الحفظ الحالي" })

vim.api.nvim_create_user_command("RehamBugDeltaToggle", function()
  M.toggle()
end, { desc = "Bug Delta: تشغيل/إيقاف المراقبة التلقائية" })

vim.api.nvim_create_user_command("RehamBugDeltaList", function()
  local added = M.new_diagnostics()
  if #added == 0 then
    notify("info", "لا توجد تشخيصات جديدة في هذا الملف")
    return
  end
  pcall(function()
    vim.diagnostic.setloclist({ title = "Bug Delta · تشخيصات جديدة" }, added)
    vim.cmd("lopen")
  end)
end, { desc = "Bug Delta: افتح قائمة التشخيصات الجديدة" })

return M