return {
	"github/copilot.vim",
	-- lazy = false,
	cmd = "Copilot",
	keys = {
		{
			"<C-l",
			'copilot#Accept("\\<CR>")',
			mode = "i",
			expr = true,
			replace_keycodes = false,
		},
	},
	config = function()
		vim.g.copilot_enabled = false
	end,
}
