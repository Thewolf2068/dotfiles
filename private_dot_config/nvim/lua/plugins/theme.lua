return{
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme "catppuccin-frappe"
    end,
    opts = {
        integrations = {
            barbar = true,
            noice = true,
            mason = true,
            indent_blankline = {
                enabled = true,
                scope_color = "",
                colored_indent_levels = true,
            },
            blink_cmp = {
                style = 'borered',
            }
        },

    }
}
