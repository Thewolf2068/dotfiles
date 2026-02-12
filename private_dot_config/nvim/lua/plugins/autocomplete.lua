return{
    {
        "Saghen/blink.cmp",
        dependencies = {
            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip', version = 'v2.*'
        },
        build = 'cargo +nightly build --release',
        -- ---@module 'blink.cmp'
        -- ---@type blink.cmp.Config
        fuzzy = { implementation = 'prefer_rust_with_warning' },

        opts = {
            snippets = { preset = 'luasnip' },
            sources = {
                default = { 'codecompanion', 'lsp', 'path', 'snippets', 'buffer' },
                per_filetype = {
                    codecompanion = { "codecompanion" },
                }
            },
            keymap = {
                preset = 'none',
                ['<C-k>'] = { 'select_prev', 'fallback' },
                ['<C-j>'] = { 'select_next', 'fallback' },

                ['<C-l>'] = { 'accept', 'fallback' }
            },
            completion = {
                menu = { border = "rounded" },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" }
                }
            }
        }
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
        end,
    },
    {
        "nvim-java/nvim-java"
    }
}
