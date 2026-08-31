---@type LazyVimConfig

vim.opt.conceallevel = 2
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
vim.opt.wrap = false

-- Set default shell
vim.opt.shell = vim.fn.has("win32") == 1 and "powershell" or "fish"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.guifont = "ComicShannsMono Nerd Font Mono:h12"
