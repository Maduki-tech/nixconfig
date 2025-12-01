-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.o

opt.swapfile = false
-- Disable ai_cmp plugin
vim.g.ai_cmp = false

opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.shiftwidth = 4
opt.tabstop = 4
