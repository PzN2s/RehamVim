--- Coder right-click menu: LSP + tasks + git + file ops.
--- Icon glyphs verified against installed Nerd fonts.
local M = {
  {
    name = "Select All",
    cmd = function()
      vim.cmd("normal! ggVG")
    end,
  },
  {
    name = "Copy Buffer",
    cmd = function()
      vim.cmd("%y+")
    end,
  },
  {
    name = "Delete Buffer",
    cmd = function()
      vim.cmd("%d")
    end,
  },
  {
    name = "Save File",
    cmd = function()
      vim.cmd("w")
    end,
  },
  {
    name = "Undo",
    cmd = function()
      vim.cmd("undo")
    end,
  },
  {
    name = "Redo",
    cmd = function()
      vim.cmd("redo")
    end,
  },
  { name = "separator" },
  {
    name = "  Go to Definition",
    cmd = vim.lsp.buf.definition,
    rtxt = "gd",
  },
  {
    name = "  Find References",
    cmd = vim.lsp.buf.references,
    rtxt = "grr",
  },
  {
    name = "  Hover Symbol",
    cmd = vim.lsp.buf.hover,
    rtxt = "K",
  },
  {
    name = "  Rename Symbol",
    cmd = vim.lsp.buf.rename,
    rtxt = "<leader>cr",
  },
  {
    name = "  Line Diagnostics",
    cmd = vim.diagnostic.open_float,
    rtxt = "<leader>cd",
  },
  { name = "separator" },
  {
    name = "  Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ lsp_fallback = true })
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },
  {
    name = "  Run Task (Overseer)",
    cmd = function()
      vim.cmd("OverseerRun")
    end,
    rtxt = "<leader>or",
  },
  {
    name = "  Terminal Here",
    cmd = function()
      vim.cmd("ToggleTerm direction=float")
    end,
  },
  {
    name = "  LazyGit",
    cmd = function()
      Snacks.lazygit.open()
    end,
    rtxt = "<leader>gg",
  },
  { name = "separator" },
  {
    name = "Blame Line",
    cmd = function()
      vim.cmd("Gitsigns blame_line")
    end,
  },
  {
    name = "Preview Hunk",
    cmd = function()
      vim.cmd("Gitsigns preview_hunk")
    end,
  },
  {
    name = "Stage Hunk",
    cmd = function()
      vim.cmd("Gitsigns stage_hunk")
    end,
  },
  {
    name = "Reset Hunk",
    cmd = function()
      vim.cmd("Gitsigns reset_hunk")
    end,
  },
  { name = "separator" },
  {
    name = "  Copy File Path",
    cmd = function()
      vim.fn.setreg("+", vim.fn.expand("%:p"))
      vim.notify("path yanked")
    end,
  },
  {
    name = " Reveal in Tree",
    cmd = function()
      vim.cmd("NvimTreeFindFile")
    end,
  },
  {
    name = " File History",
    cmd = function()
      vim.cmd("DiffviewFileHistory %")
    end,
  },
}

return M
