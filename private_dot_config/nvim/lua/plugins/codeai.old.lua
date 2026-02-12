return{
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        ---@module "codecompanion"
        ---@type CodeCompanion.Config
        display = {
            chat = {
                window = { position = "right", width = 0.4 } } },
                -- Set Mistral as the default adapter for all strategies
                strategies = {
                    chat = { adapter = "mistral", model = "devstral-small", name = "devstral"},
                    inline = { adapter = "mistral", model = "devstral-small" },
                    agent = { adapter = "mistral", model = "devstral-small" },
                },
                -- Configure the Mistral adapter
                adapters = {
                    http = {
                        mistral = function()
                            return require("codecompanion.adapters").extend("mistral", {
                                env = {
                                    api_key = "cmd:cat ~/.mistral_api_key.txt 2>/dev/null", -- Replace with your actual API key
                                },
                            })
                        end,
                    },
                },
                -- Optional: Set log level for debugging
                opts = {
                    log_level = "DEBUG",
                },
            },
        }
