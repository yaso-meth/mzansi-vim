return {
	"github/copilot.vim",
	lazy = false,
	config = function()
		vim.g.copilot_enabled = false
		vim.g.copilot_no_tab_map = true
		vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false
		})
	end,
}
