vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



require("config.lazy")

local builtin = require('telescope.builtin')

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4        -- A tab is 4 spaces
vim.opt.shiftwidth = 4     -- Indentation level is 4 spaces
vim.opt.expandtab = true   -- Use spaces instead of tab characters


vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to down split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to up split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })


vim.keymap.set('n', '<Tab>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })

vim.keymap.set('n', '<C-t>', '<Cmd>Dashboard<CR>', { desc = 'Open dashboard with Ctrl-t'})
vim.keymap.set('n', '<C-w>', '<Cmd>bd<CR>', { desc = 'Close buffer like a browser tab'})

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.cmd.colorscheme "catppuccin-frappe"
