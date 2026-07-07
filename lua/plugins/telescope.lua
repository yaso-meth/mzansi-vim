return {
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- optional but recommended
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"%.dart_tool/",
					"%.flatpak%-builder/",
					"%.idea/",
					"%.git/",
					"build/",
					"build%-dir/",
					"android/",
					"ios/",
					"linux/",
					"macos/",
					"windows/",
					"web/",
					"%.g%.dart$", -- Catches generated files in find_files too
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--glob=!**/*.g.dart", -- Ignore all .g.dart files
					"--glob=!**/hive_registrar.g.dart", -- Specifically ignore your registry
				},
			},
		})
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
	end
}
