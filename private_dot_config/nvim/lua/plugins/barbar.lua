return {
  'romgrk/barbar.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional (for icons)
    'lewis6991/gitsigns.nvim',     -- optional (for git status)
  },
  init = function()
    vim.g.barbar_auto_setup = false -- disable auto-setup
  end,
  config = function()
    require('barbar').setup {
      -- your config here or leave empty for defaults
    }
  end,
}

