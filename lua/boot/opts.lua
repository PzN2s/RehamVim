---@type LazyVimConfig

vim.opt.conceallevel = 2
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
vim.opt.wrap = false

-- Set default shell: prefer fish when installed (RehamVim is tuned for it),
-- otherwise fall back to the user's own default shell so other setups don't
-- break when fish is missing.
vim.opt.shell = vim.fn.has("win32") == 1 and "powershell" or (vim.fn.executable("fish") == 1 and "fish" or vim.o.shell)
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.guifont = "ComicShannsMono Nerd Font Mono:h12"
