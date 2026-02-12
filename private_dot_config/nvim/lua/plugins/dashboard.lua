return {
    'nvimdev/dashboard-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VimEnter',
    config = function()
        local ascii_art = {}
        for line in io.lines(vim.fn.stdpath('config') .. '/lua/plugins/ascii/asuka.txt') do
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
                        desc = '󰒲 Lazy',
                        group = 'Lazy',
                        action = 'Lazy',
                        key = 'l',
                    }
                },
                project = { enable = false },
            },
        }
    end,
}
