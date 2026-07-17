vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.splitbelow = true -- Opens horizontal splits below
vim.opt.splitright = true -- Opens vertical splits to the right
-- Disable legacy vim bracket matching engine (fixes newline/brace layout latency)
-- vim.g.loaded_matchparen = 0
