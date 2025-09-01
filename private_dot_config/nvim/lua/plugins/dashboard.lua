return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local ascii_art = {}
    for line in io.lines(vim.fn.stdpath('config') .. '/lua/plugins/dashboard.txt') do
      table.insert(ascii_art, line)
    end

    require('dashboard').setup {
      theme = 'hyper',
      config = {
        header = ascii_art, -- embed ASCII art directly
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = ' Apps',
            group = 'DiagnosticHint',
            action = 'Telescope app',
            key = 'a',
          },
          {
            desc = ' dotfiles',
            group = 'Number',
            action = 'Telescope dotfiles',
            key = 'd',
          },
        },
        project = { enable = false },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
