vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("core.lsp")
require("core.lazy")
require("settings.options")
require("settings.keymaps")


-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

