---@type LazyVimConfig

vim.opt.conceallevel = 2
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
vim.opt.wrap = false
-- Emoji count as double-width cells (matches kitty's rendering), so centered
-- text containing emoji aligns exactly instead of drifting sideways.
vim.opt.emoji = true

-- Set default shell: prefer fish when installed (RehamVim is tuned for it),
-- otherwise fall back to the user's own default shell so other setups don't
-- break when fish is missing.
vim.opt.shell = vim.fn.has("win32") == 1 and "powershell" or (vim.fn.executable("fish") == 1 and "fish" or vim.o.shell)
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.guifont = "ComicShannsMono Nerd Font Mono:h12"

-- Rounded borders on every floating window (matches the theme).
vim.opt.winborder = "rounded"

-- Keep the view stable when splitting, and allow the cursor past end
-- of line in visual-block mode (column edits).
vim.opt.splitkeep = "screen"
vim.opt.virtualedit = "block"

-- Smarter file completion: skip junk dirs, resolve extensions on gf.
vim.opt.wildignore:append({ "node_modules", ".git", "target", "dist", "build", "*.o", "*.a" })
vim.opt.suffixesadd:append({ ".lua", ".js", ".ts", ".tsx", ".py", ".go", ".rs", ".nix" })

-- System clipboard for all yanks/pastes (Wayland wl-copy present).
vim.opt.clipboard = "unnamedplus"
