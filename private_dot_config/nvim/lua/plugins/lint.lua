return {
    "mfussenegger/nvim-lint",

    -- Load when opening Java files (recommended for performance)
    ft = { "java" },

    config = function()
        local lint = require("lint")

        -- Custom Checkstyle linter definition
        lint.linters.checkstyle = {
            cmd = "checkstyle",        -- uses system install (Arch AUR)
            stdin = false,
            args = function(ctx)
                -- 1. Prefer project checkstyle.xml if present (best practice)
                local project_config = ctx.root .. "/checkstyle.xml"

                -- 2. Fallback to global config (edit path)
                local global_config = "/path/to/your/global/checkstyle.xml"

                if vim.fn.filereadable(project_config) == 1 then
                    return { "-c", project_config, "-f", "xml" }
                else
                    return { "-c", global_config, "-f", "xml" }
                end
            end,
        }

        -- Enable checkstyle for Java
        lint.linters_by_ft = {
            java = { "checkstyle" },
        }

        -- Auto run lint on save + exit insert mode (smooth workflow)
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
