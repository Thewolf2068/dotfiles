return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#292c3c',
				base01 = '#292c3c',
				base02 = '#918a95',
				base03 = '#918a95',
				base04 = '#ebe3f1',
				base05 = '#fcf8ff',
				base06 = '#fcf8ff',
				base07 = '#fcf8ff',
				base08 = '#ff9faf',
				base09 = '#ff9faf',
				base0A = '#e2b9fd',
				base0B = '#a5ffbb',
				base0C = '#f1dbff',
				base0D = '#e2b9fd',
				base0E = '#e9c7ff',
				base0F = '#e9c7ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#918a95',
				fg = '#fcf8ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#e2b9fd',
				fg = '#292c3c',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#918a95' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f1dbff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#e9c7ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#e2b9fd',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#e2b9fd',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#f1dbff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffbb',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#ebe3f1' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ebe3f1' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#918a95',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
