-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
-- keymap.set("i", "<tab>", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("n", "<A-j>", "5j", { desc = "Scroll 5 lines down" })
keymap.set("n", "<A-k>", "5k", { desc = "Scroll 5 lines up" })
keymap.set("n", "<Leader>j", "J", { desc = "join lines" })
keymap.set('n', '<leader>wf', ':set winfixbuf<CR>', { noremap = true, silent = true })
keymap.set('n', '<leader>wn', ':set nowinfixbuf<CR>', { noremap = true, silent = true })
