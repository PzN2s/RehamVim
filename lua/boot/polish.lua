-- Small distinctive polish: relative numbers that adapt to mode,
-- yank flash, auto-mkdir on save, cursor restore, per-project scratchpad.
-- Plain autocmds/keymaps only: zero plugins, zero cost.

local group = vim.api.nvim_create_augroup("RehamPolish", { clear = true })

-- Relative numbers in normal mode, absolute while typing.
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.opt.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Flash yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 150 })
  end,
})

-- Auto-create missing parent directories on save (never for remote paths).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(ev)
    local dir = vim.fn.fnamemodify(ev.file, ":p:h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 and not dir:match("^%w+://") then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Restore cursor to last position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- :CopyCode — yank buffer (or visual selection) as a fenced markdown
-- code block, ready to paste into a chat/issue (<leader>cy).
vim.api.nvim_create_user_command("CopyCode", function(opts)
  local lines
  if opts.range == 0 then
    lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  else
    lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  end
  local text = "```" .. vim.bo.filetype .. "\n" .. table.concat(lines, "\n") .. "\n```"
  vim.fn.setreg("+", text)
  vim.notify("copied " .. #lines .. " lines as fenced " .. vim.bo.filetype .. " block")
end, { desc = "Copy code as fenced block", range = true })
vim.keymap.set({ "n", "x" }, "<leader>cy", ":CopyCode<cr>", { desc = "Copy Code Block" })

-- :CopyRef — yank "file:line" (or "file:start-end" for a selection),
-- handy when pointing an AI or a teammate at code (<leader>cL).
vim.api.nvim_create_user_command("CopyRef", function(opts)
  local ref = vim.fn.expand("%")
  if opts.range == 0 then
    ref = ref .. ":" .. math.max(1, vim.api.nvim_win_get_cursor(0)[1])
  else
    ref = ref .. ":" .. opts.line1 .. "-" .. opts.line2
  end
  vim.fn.setreg("+", ref)
  vim.notify("copied " .. ref)
end, { desc = "Copy file:line reference", range = true })
vim.keymap.set({ "n", "x" }, "<leader>cL", ":CopyRef<cr>", { desc = "Copy File:Line Ref" })

-- :UUID — insert a fresh UUID at the cursor (<leader>cu).
vim.api.nvim_create_user_command("UUID", function()
  local ok, lines = pcall(vim.fn.readfile, "/proc/sys/kernel/random/uuid")
  if not ok or not lines or not lines[1] or lines[1] == "" then
    vim.notify("UUID: no system uuid available", vim.log.levels.WARN)
    return
  end
  local id = lines[1]:gsub("%s+", "")
  vim.api.nvim_put({ id }, "c", true, true)
end, { desc = "Insert UUID" })
vim.keymap.set("n", "<leader>cu", ":UUID<cr>", { desc = "Insert UUID" })

-- :BufClean — wipe hidden listed buffers, keeping modified ones safe.
vim.api.nvim_create_user_command("BufClean", function()
  local visible = {}
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(w)] = true
  end
  local n = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and not visible[b] and not vim.bo[b].modified then
      vim.api.nvim_buf_delete(b, {})
      n = n + 1
    end
  end
  vim.notify("wiped " .. n .. " hidden buffer(s)")
end, { desc = "Wipe hidden buffers" })

-- :BufOnly — close all listed buffers except the current one (modified kept).
vim.api.nvim_create_user_command("BufOnly", function()
  local cur = vim.api.nvim_get_current_buf()
  local n = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and not vim.bo[b].modified then
      vim.api.nvim_buf_delete(b, {})
      n = n + 1
    end
  end
  vim.notify("closed " .. n .. " buffer(s)")
end, { desc = "Close all buffers but current" })

-- :ChmodX — toggle the executable bit on the current file.
vim.api.nvim_create_user_command("ChmodX", function()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.notify("ChmodX: no file", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable(file) == 1 then
    vim.fn.system({ "chmod", "-x", file })
    vim.notify("executable bit removed")
  else
    vim.fn.system({ "chmod", "+x", file })
    vim.notify("executable bit set")
  end
end, { desc = "Toggle executable bit" })
vim.api.nvim_create_user_command("DiffOrig", function()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.notify("DiffOrig: save the file first", vim.log.levels.WARN)
    return
  end
  local content = vim.fn.readfile(file)
  vim.cmd("vert new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")
end, { desc = "Diff buffer against saved file" })

-- Per-project floating scratchpad (<leader>.): one notes file per cwd.
vim.keymap.set("n", "<leader>.", function()
  local dir = vim.fn.stdpath("data") .. "/scratch"
  vim.fn.mkdir(dir, "p")
  local name = dir .. "/" .. vim.fn.getcwd():gsub("[^%w]+", "_") .. ".md"
  local buf = vim.fn.bufadd(name)
  vim.fn.bufload(buf)
  vim.bo[buf].filetype = "markdown"
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " scratch ",
    title_pos = "center",
  })
end, { desc = "Project Scratchpad" })

-- New script files start with a shebang; files carrying one become
-- executable on first save. Both are quiet no-ops otherwise.
vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("RehamShebang", { clear = true }),
  pattern = { "*.sh", "*.bash", "*.py" },
  callback = function(ev)
    local line = "#!/usr/bin/env python3"
    if ev.file:match("%.sh$") or ev.file:match("%.bash$") then
      line = "#!/bin/sh"
    end
    if vim.api.nvim_buf_line_count(ev.buf) == 1 and vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] == "" then
      vim.api.nvim_buf_set_lines(ev.buf, 0, 1, false, { line })
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "RehamShebang",
  callback = function(ev)
    local first = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] or ""
    if first:sub(1, 2) == "#!" and vim.fn.executable(ev.file) ~= 1 then
      vim.fn.system({ "chmod", "+x", ev.file })
    end
  end,
})

-- Daily streak: consecutive days with an nvim session (:Streak to view).
local function streak_bump()
  local f = vim.fn.stdpath("data") .. "/streak"
  local ok, lines = pcall(vim.fn.readfile, f)
  local last, count = "", 0
  if ok and lines and #lines >= 1 then
    local d, c = lines[1]:match("^(%d%d%d%d%-%d%d%-%d%d)%s+(%d+)$")
    if d then
      last, count = d, tonumber(c) or 0
    end
  end
  local today = os.date("%Y-%m-%d")
  if last == today then
    return count
  end
  local yday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
  count = (last == yday) and (count + 1) or 1
  pcall(vim.fn.writefile, { today .. " " .. count }, f)
  return count
end
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("RehamStreak", { clear = true }),
  callback = function()
    vim.schedule(streak_bump)
  end,
})
vim.api.nvim_create_user_command("Streak", function()
  vim.notify("streak: " .. streak_bump() .. " day(s)", vim.log.levels.INFO)
end, { desc = "Show coding streak" })

-- :RetabSpaces / :RetabTabs — convert indentation (range or whole buffer).
vim.api.nvim_create_user_command("RetabSpaces", function(opts)
  vim.opt_local.expandtab = true
  vim.cmd(opts.line1 .. "," .. opts.line2 .. "retab")
  vim.notify("indented with spaces")
end, { desc = "Retab to spaces", range = "%" })
vim.api.nvim_create_user_command("RetabTabs", function(opts)
  vim.opt_local.expandtab = false
  vim.cmd(opts.line1 .. "," .. opts.line2 .. "retab!")
  vim.notify("indented with tabs")
end, { desc = "Retab to tabs", range = "%" })

-- :Trim — strip trailing whitespace in the buffer (explicit only).
vim.api.nvim_create_user_command("Trim", function(opts)
  local from, to = opts.line1, opts.line2
  local lines = vim.api.nvim_buf_get_lines(0, from - 1, to, false)
  for i, l in ipairs(lines) do
    lines[i] = l:gsub("%s+$", "")
  end
  vim.api.nvim_buf_set_lines(0, from - 1, to, false, lines)
end, { desc = "Trim trailing whitespace", range = "%" })

-- :UrlEncode / :UrlDecode — percent-encoding for the range (API work).
local function url_codec(decode)
  return function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    for i, l in ipairs(lines) do
      if decode then
        lines[i] = l:gsub("%%(%x%x)", function(h)
          return string.char(tonumber(h, 16))
        end)
      else
        lines[i] = l:gsub("([^A-Za-z0-9%-%._~])", function(c)
          return string.format("%%%02X", string.byte(c))
        end)
      end
    end
    vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, lines)
  end
end
vim.api.nvim_create_user_command("UrlEncode", url_codec(false), { desc = "Percent-encode range", range = true })
vim.api.nvim_create_user_command("UrlDecode", url_codec(true), { desc = "Percent-decode range", range = true })

-- :CopyName — yank current file's basename.
vim.api.nvim_create_user_command("CopyName", function()
  local name = vim.fn.expand("%:t")
  vim.fn.setreg("+", name)
  vim.notify("copied " .. name)
end, { desc = "Copy file basename" })

-- :Daily — open today's journal page (prefilled when new).
vim.api.nvim_create_user_command("Daily", function()
  local dir = vim.fn.stdpath("data") .. "/journal"
  vim.fn.mkdir(dir, "p")
  local path = dir .. "/" .. os.date("%Y-%m-%d") .. ".md"
  local is_new = vim.fn.filereadable(path) == 0
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  if is_new then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. os.date("%Y-%m-%d"), "", "- " })
    vim.api.nvim_win_set_cursor(0, { 3, 2 })
  end
end, { desc = "Open today's journal" })

-- :Msg — open :messages in a scratch buffer (copy/share errors easily).
vim.api.nvim_create_user_command("Msg", function()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.fn.execute("messages"), "\n"))
end, { desc = "Open messages in buffer" })

-- :LspLog / :DapLog — open the corresponding log file for debugging.
for _, spec in ipairs({ { "LspLog", "lsp.log" }, { "DapLog", "dap.log" } }) do
  vim.api.nvim_create_user_command(spec[1], function()
    local path = vim.fn.stdpath("state") .. "/" .. spec[2]
    if vim.fn.filereadable(path) == 0 then
      vim.notify(spec[2] .. " does not exist yet", vim.log.levels.WARN)
      return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end, { desc = "Open " .. spec[2] })
end

-- :Journal — browse the journal directory (via oil; netrw is disabled).
vim.api.nvim_create_user_command("Journal", function()
  local dir = vim.fn.stdpath("data") .. "/journal"
  vim.fn.mkdir(dir, "p")
  vim.cmd("Oil " .. vim.fn.fnameescape(dir))
end, { desc = "Browse journal directory" })

-- :GrepNotes — live grep inside the journal (not all of data/).
vim.api.nvim_create_user_command("GrepNotes", function()
  local dir = vim.fn.stdpath("data") .. "/journal"
  vim.fn.mkdir(dir, "p")
  Snacks.picker.grep({ cwd = dir })
end, { desc = "Grep journal" })

-- :Dotfiles — open this config in oil (netrw is disabled).
vim.api.nvim_create_user_command("Dotfiles", function()
  vim.cmd("Oil " .. vim.fn.fnameescape(vim.fn.stdpath("config")))
end, { desc = "Open nvim config directory" })

-- :Reload — restart nvim in place (a plain re-source would reuse cached
-- modules and choke on duplicate commands; restart picks up everything).
vim.api.nvim_create_user_command("Reload", function()
  vim.cmd("restart")
end, { desc = "Restart nvim" })

-- Common typo fixes while typing.
vim.cmd("inoreabbrev teh the")
vim.cmd("inoreabbrev adn and")
vim.cmd("inoreabbrev recieve receive")
vim.cmd("inoreabbrev seperate separate")
vim.cmd("inoreabbrev functoin function")
vim.cmd("inoreabbrev occured occurred")
vim.cmd("inoreabbrev exmaple example")
vim.cmd("inoreabbrev retrun return")

-- :YankDiagnostics — copy buffer diagnostics as file:line:col: message lines.
-- (implementation follows below)
vim.api.nvim_create_user_command("YankDiagnostics", function()
  local fname = vim.fn.expand("%")
  local out = {}
  for _, d in ipairs(vim.diagnostic.get(0)) do
    local sev = ({ "E", "W", "I", "H" })[d.severity] or "?"
    out[#out + 1] = string.format("%s:%d:%d: [%s] %s", fname, d.lnum + 1, d.col + 1, sev, d.message:gsub("\n", " "))
  end
  if #out == 0 then
    vim.notify("no diagnostics in buffer")
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " diagnostic(s)")
end, { desc = "Copy buffer diagnostics" })

-- :YankDiff — copy `git diff` (unstaged) for sharing/review.
vim.api.nvim_create_user_command("YankDiff", function()
  local out = vim.fn.systemlist("git diff --no-color")
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("no unstaged diff (or not a repo)", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied diff (" .. #out .. " lines)")
end, { desc = "Copy git diff" })

-- :YankBranch — copy current branch name. :YankRemote — copy origin URL.
vim.api.nvim_create_user_command("YankBranch", function()
  local out = vim.fn.systemlist("git branch --show-current")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    vim.notify("not on a branch", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", out[1])
  vim.notify("copied branch " .. out[1])
end, { desc = "Copy branch name" })
vim.api.nvim_create_user_command("YankRemote", function()
  local out = vim.fn.systemlist("git remote get-url origin")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    vim.notify("no origin remote", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", out[1])
  vim.notify("copied " .. out[1])
end, { desc = "Copy origin URL" })

-- :YankStaged — copy staged diff. :YankLog — copy recent log lines.
-- :YankBlame — copy blame info for the current line.
vim.api.nvim_create_user_command("YankStaged", function()
  local out = vim.fn.systemlist("git diff --cached --no-color")
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("nothing staged", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied staged diff (" .. #out .. " lines)")
end, { desc = "Copy staged diff" })
vim.api.nvim_create_user_command("YankLog", function()
  local out = vim.fn.systemlist("git log --oneline -15 --no-color")
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("no git log here", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " log lines")
end, { desc = "Copy recent git log" })
vim.api.nvim_create_user_command("YankBlame", function()
  local file = vim.fn.expand("%:p")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  if file == "" then
    vim.notify("no file", vim.log.levels.WARN)
    return
  end
  local out = vim.fn.systemlist({ "git", "blame", "-L", line .. "," .. line, "--porcelain", file })
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("blame failed (not tracked?)", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied blame for line " .. line)
end, { desc = "Copy blame for current line" })

-- :YankStatus — copy `git status --short`.
vim.api.nvim_create_user_command("YankStatus", function()
  local out = vim.fn.systemlist("git status --short --no-color")
  if vim.v.shell_error ~= 0 then
    vim.notify("not a repo", vim.log.levels.WARN)
    return
  end
  if #out == 0 then
    vim.notify("working tree clean")
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied status (" .. #out .. " lines)")
end, { desc = "Copy git status" })

-- :GitRoot — cd to the repo toplevel.
vim.api.nvim_create_user_command("GitRoot", function()
  local out = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    vim.notify("not in a repo", vim.log.levels.WARN)
    return
  end
  vim.cmd("cd " .. vim.fn.fnameescape(out[1]))
  vim.notify("cwd: " .. out[1])
end, { desc = "Cd to repo root" })

-- :FileInfo — size, lines, type, encoding and indent of current file.
vim.api.nvim_create_user_command("FileInfo", function()
  local file = vim.fn.expand("%:p")
  local size = file ~= "" and vim.fn.getfsize(file) or -1
  local function human(n)
    if n < 0 then
      return "?"
    end
    local u = { "B", "KB", "MB", "GB" }
    local i = 1
    while n >= 1024 and i < #u do
      n = n / 1024
      i = i + 1
    end
    return string.format("%.1f %s", n, u[i])
  end
  vim.notify(
    string.format(
      "%s | %s | %d lines | %s | %s | sw=%d ts=%d %s",
      vim.fn.fnamemodify(file, ":t"),
      human(size),
      vim.api.nvim_buf_line_count(0),
      vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding,
      vim.bo.fileformat,
      vim.bo.shiftwidth,
      vim.bo.tabstop,
      vim.bo.expandtab and "spaces" or "tabs"
    )
  )
end, { desc = "Show file info" })

-- :YankSearch — copy last search pattern. :YankReg {r} — copy register.
vim.api.nvim_create_user_command("YankSearch", function()
  local pat = vim.fn.getreg("/")
  if pat == "" then
    vim.notify("no last search", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", pat)
  vim.notify("copied /" .. pat)
end, { desc = "Copy last search" })
vim.api.nvim_create_user_command("YankReg", function(opts)
  local name = opts.args ~= "" and opts.args or '"'
  local val = vim.fn.getreg(name)
  vim.fn.setreg("+", val)
  vim.notify("copied @" .. name .. " (" .. #val .. " chars)")
end, { desc = "Copy register to clipboard", nargs = "?" })

-- :YankCmd — copy last Ex command. :YankOldfiles — copy recent files.
vim.api.nvim_create_user_command("YankCmd", function()
  local cmd = vim.fn.histget(":") or ""
  if cmd == "" then
    vim.notify("no command history", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", cmd)
  vim.notify("copied :" .. cmd)
end, { desc = "Copy last Ex command" })
vim.api.nvim_create_user_command("YankOldfiles", function()
  local files = {}
  for _, f in ipairs(vim.v.oldfiles) do
    if vim.fn.filereadable(f) == 1 then
      files[#files + 1] = f
      if #files >= 20 then
        break
      end
    end
  end
  if #files == 0 then
    vim.notify("no recent files", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(files, "\n"))
  vim.notify("copied " .. #files .. " file(s)")
end, { desc = "Copy recent files" })

-- :YankAutocmds [group] — copy autocmd definitions (debugging).
vim.api.nvim_create_user_command("YankAutocmds", function(opts)
  local aus = vim.api.nvim_get_autocmds(opts.args ~= "" and { group = opts.args } or {})
  local out = {}
  for _, a in ipairs(aus) do
    out[#out + 1] = (a.group_name or "-") .. " | " .. (a.event or "?") .. " | " .. (a.pattern or a.buffer or "-")
  end
  if #out == 0 then
    vim.notify("no autocmds found", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " autocmd(s)")
end, { desc = "Copy autocmd list", nargs = "?" })

-- :YankArgs — copy arglist files. :YankMarks — copy global marks (A-Z).
-- :YankRuntime — copy runtimepath entries (debugging load issues).
vim.api.nvim_create_user_command("YankArgs", function()
  if vim.fn.argc() == 0 then
    vim.notify("arglist empty", vim.log.levels.WARN)
    return
  end
  local out = {}
  for i = 0, vim.fn.argc() - 1 do
    out[#out + 1] = vim.fn.argv(i)
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " arg(s)")
end, { desc = "Copy arglist" })
vim.api.nvim_create_user_command("YankMarks", function()
  local out = {}
  for _, m in ipairs(vim.fn.getmarklist()) do
    if m.mark:match("^[A-Z]$") and m.file and m.file ~= "" then
      out[#out + 1] = m.mark .. " " .. m.file .. ":" .. (m.pos and m.pos[2] or 0)
    end
  end
  if #out == 0 then
    vim.notify("no global marks", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " mark(s)")
end, { desc = "Copy global marks" })
vim.api.nvim_create_user_command("YankRuntime", function()
  local out = vim.split(vim.o.runtimepath, ",", { plain = true })
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " rtp entries")
end, { desc = "Copy runtimepath" })

-- :YankCommit — copy short HEAD hash. :YankTag — copy latest tag.
vim.api.nvim_create_user_command("YankCommit", function()
  local out = vim.fn.systemlist("git rev-parse --short HEAD")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    vim.notify("not a repo", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", out[1])
  vim.notify("copied " .. out[1])
end, { desc = "Copy HEAD hash" })
vim.api.nvim_create_user_command("YankTag", function()
  local out = vim.fn.systemlist("git describe --tags --abbrev=0")
  if vim.v.shell_error ~= 0 or #out == 0 or out[1] == "" then
    vim.notify("no tags found", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", out[1])
  vim.notify("copied " .. out[1])
end, { desc = "Copy latest tag" })

-- :YankDiffFile — copy diff of just the current file.
vim.api.nvim_create_user_command("YankDiffFile", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("no file", vim.log.levels.WARN)
    return
  end
  local out = vim.fn.systemlist({ "git", "diff", "--no-color", "--", file })
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("no diff for this file", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied file diff (" .. #out .. " lines)")
end, { desc = "Copy current file diff" })

-- :YankLogFile — copy recent log lines touching the current file.
vim.api.nvim_create_user_command("YankLogFile", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("no file", vim.log.levels.WARN)
    return
  end
  local out = vim.fn.systemlist({ "git", "log", "--oneline", "-10", "--no-color", "--", file })
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("no history for this file", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " log lines")
end, { desc = "Copy file history log" })

-- :PluginList — copy installed plugin names (comma-separated).
vim.api.nvim_create_user_command("PluginList", function()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.notify("lazy not available", vim.log.levels.WARN)
    return
  end
  local names = {}
  for _, p in ipairs(lazy.plugins()) do
    names[#names + 1] = p.name
  end
  table.sort(names)
  vim.fn.setreg("+", table.concat(names, ", "))
  vim.notify(#names .. " plugins copied")
end, { desc = "Copy plugin list" })

-- :LspRestart — restart buffer clients (reattach via FileType).
vim.api.nvim_create_user_command("LspRestart", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("no LSP clients on buffer", vim.log.levels.WARN)
    return
  end
  for _, c in ipairs(clients) do
    vim.lsp.stop_client(c.id, true)
  end
  vim.defer_fn(function()
    vim.cmd("edit")
  end, 500)
end, { desc = "Restart LSP clients" })

-- :YankLogGrep <pattern> — copy commits that added/removed a string.
vim.api.nvim_create_user_command("YankLogGrep", function(opts)
  if opts.args == "" then
    vim.notify("usage: YankLogGrep <pattern>", vim.log.levels.WARN)
    return
  end
  local out = vim.fn.systemlist({ "git", "log", "--oneline", "-S", opts.args, "--no-color" })
  if vim.v.shell_error ~= 0 or #out == 0 then
    vim.notify("no commits touch '" .. opts.args .. "'", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " commit(s)")
end, { desc = "Copy pickaxe log", nargs = 1 })

-- :Dashboard — reopen the home screen.
vim.api.nvim_create_user_command("Dashboard", function()
  Snacks.dashboard.open()
end, { desc = "Open dashboard" })

-- :DiffStaged — review staged changes in diffview.
vim.api.nvim_create_user_command("DiffStaged", function()
  vim.cmd("DiffviewOpen --cached")
end, { desc = "Review staged changes" })

-- :DiffBranch [base] — diff current branch against base (default: main).
vim.api.nvim_create_user_command("DiffBranch", function(opts)
  local base = opts.args ~= "" and opts.args or "main"
  vim.cmd("DiffviewOpen " .. vim.fn.shellescape(base) .. "...HEAD")
end, {
  desc = "Diff branch against base",
  nargs = "?",
  complete = function()
    return vim.fn.systemlist("git branch --format='%(refname:short)'")
  end,
})

-- :YankCwd — copy working directory. :YankEnv VAR / :YankWhich bin —
-- copy env values and binary paths (PATH debugging).
vim.api.nvim_create_user_command("YankCwd", function()
  vim.fn.setreg("+", vim.fn.getcwd())
  vim.notify("copied " .. vim.fn.getcwd())
end, { desc = "Copy working directory" })
vim.api.nvim_create_user_command("YankEnv", function(opts)
  local val = vim.env[opts.args]
  if val == nil or val == "" then
    vim.notify("env " .. opts.args .. " is empty", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", val)
  vim.notify("copied $" .. opts.args)
end, { desc = "Copy env var value", nargs = 1 })
vim.api.nvim_create_user_command("YankWhich", function(opts)
  local path = vim.fn.exepath(opts.args)
  if path == "" then
    vim.notify(opts.args .. " not on PATH", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("copied " .. path)
end, { desc = "Copy binary path", nargs = 1 })

-- :YankLsp — copy attached clients (name + root) for debugging.
vim.api.nvim_create_user_command("YankLsp", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("no LSP clients on buffer", vim.log.levels.WARN)
    return
  end
  local out = {}
  for _, c in ipairs(clients) do
    local root = (c.config and c.config.root_dir) or "-"
    out[#out + 1] = c.name .. " @ " .. root
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " client(s)")
end, { desc = "Copy attached LSP clients" })

-- :YankBuffers — copy open buffer paths (one per line).
vim.api.nvim_create_user_command("YankBuffers", function()
  local out = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= "" then
        out[#out + 1] = name
      end
    end
  end
  if #out == 0 then
    vim.notify("no named buffers", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " buffer(s)")
end, { desc = "Copy open buffer paths" })

-- :RunThis — run the current file with the right runner.
vim.api.nvim_create_user_command("RunThis", function()
  local runners = { python = "python3", sh = "sh", bash = "bash", lua = "nvim --headless -l", javascript = "node" }
  local ft = vim.bo.filetype
  local bin = runners[ft]
  if not bin then
    vim.notify("no runner for " .. ft, vim.log.levels.WARN)
    return
  end
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("no file", vim.log.levels.WARN)
    return
  end
  vim.cmd("w")
  vim.cmd("split | terminal " .. bin .. " " .. vim.fn.shellescape(file))
end, { desc = "Run current file" })

-- :YankTools — copy versions of key dev tools (for bug reports).
vim.api.nvim_create_user_command("YankTools", function()
  local tools = { "rg", "fd", "node", "python3", "go", "cargo", "git" }
  local out = {}
  for _, t in ipairs(tools) do
    if vim.fn.executable(t) == 1 then
      local flag = t == "go" and "version" or "--version"
      local v = vim.fn.systemlist(t .. " " .. flag)
      out[#out + 1] = t .. ": " .. ((v and v[1]) or "?")
    else
      out[#out + 1] = t .. ": MISSING"
    end
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied tool versions")
end, { desc = "Copy tool versions" })

-- :YankHealthErrors — copy checkhealth error lines only.
vim.api.nvim_create_user_command("YankHealthErrors", function()
  local lines = vim.split(vim.fn.execute("checkhealth"), "\n")
  local errs = {}
  for _, l in ipairs(lines) do
    if l:find("ERROR") then
      errs[#errs + 1] = l
    end
  end
  if #errs == 0 then
    vim.notify("no health errors")
    return
  end
  vim.fn.setreg("+", table.concat(errs, "\n"))
  vim.notify("copied " .. #errs .. " error line(s)")
end, { desc = "Copy health errors" })

-- :YankQuickfix — copy quickfix entries as file:line:col: text.
vim.api.nvim_create_user_command("YankQuickfix", function()
  local items = vim.fn.getqflist()
  if #items == 0 then
    vim.notify("quickfix list is empty", vim.log.levels.WARN)
    return
  end
  local out = {}
  for _, it in ipairs(items) do
    local name = it.bufnr and it.bufnr > 0 and vim.api.nvim_buf_get_name(it.bufnr) or ""
    out[#out + 1] = string.format("%s:%d:%d: %s", name, it.lnum or 0, it.col or 0, it.text or "")
  end
  vim.fn.setreg("+", table.concat(out, "\n"))
  vim.notify("copied " .. #out .. " quickfix entries")
end, { desc = "Copy quickfix list" })
