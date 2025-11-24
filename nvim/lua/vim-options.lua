-- Basics
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80,100"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Leader key
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

