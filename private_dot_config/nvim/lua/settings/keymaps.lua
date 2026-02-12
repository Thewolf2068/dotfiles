vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to down split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to up split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })


vim.keymap.set('n', '<Tab>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })

vim.keymap.set('n', '<C-t>', '<Cmd>Dashboard<CR>', { desc = 'Open dashboard with Ctrl-t'})

vim.keymap.set('n', '<C-b>', '<Cmd>bd<CR>', { desc = 'Close buffer' })

-- Telescope stuff
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Floating Terminal
vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle Floating Terminal'})
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]],{noremap=true})

--resize buffer
vim.keymap.set('n', '<C-Left>', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize -5<CR>', { noremap = true, silent = true })

--neotree
vim.keymap.set('n', '<leader>nt', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle neotree' })

--CodeCompanion
vim.keymap.set('n', '<leader>cc', '<Cmd>CodeCompanionActions<CR>', {desc = 'Open CodeCompanion actions window' })

