-- Extra LSP servers, configured directly (always applied).
-- Emmet for web files: expand abbreviations (e.g. `div>ul>li*3`) with <Tab>.
vim.lsp.config("emmet_language_server", {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
})

for _, name in ipairs({ "emmet_language_server", "tinymist", "texlab", "svelte", "lemminx", "neocmake" }) do
  vim.lsp.enable(name)
end

-- marksman: mason's binary is dynamically linked and cannot start on NixOS
-- (stub-ld), which spammed lsp.log on every markdown file. Use the Nix one
-- when it exists, otherwise whatever PATH provides.
vim.lsp.config("marksman", {
  cmd = { require("lib.toolpath").bin("marksman"), "server" },
})
vim.lsp.enable("marksman")

-- pyright complains 'File or directory "/<default workspace root>" does not
-- exist.' for a python file that sits outside any project, because it receives
-- no workspace root at all. Keep the usual markers and fall back to the file's
-- own directory so the server always gets a real workspace.
vim.lsp.config("pyright", {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "pyrightconfig.json",
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      ".git",
    })
    if root then
      on_dir(root)
      return
    end
    local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    on_dir(dir ~= "" and dir or vim.fn.getcwd())
  end,
})

-- Duplicate-client guard: two enable paths (ours + lspconfig/mason
-- auto-enable) can race and attach the SAME server twice to one buffer.
-- Sweep after every attach and keep a single client per name+root.
-- Multi-root setups (different root_dir) are unaffected.
local function dedup_lsp()
  local seen = {}
  for _, c in ipairs(vim.lsp.get_clients()) do
    local key = c.name .. "@" .. ((c.config and c.config.root_dir) or "-")
    if seen[key] then
      vim.lsp.stop_client(c.id, true)
    else
      seen[key] = true
    end
  end
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("RehamLspDedup", { clear = true }),
  callback = function()
    vim.schedule(dedup_lsp)
  end,
})
