return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		-- Customize these keymaps to your liking!
		{
			"<leader>cd",
			function()
				require("yazi").yazi()
			end,
			desc = "Open yazi at the current file",
		},
		{
			-- Open in the current working directory
			"<leader>cw",
			function()
				require("yazi").yazi(nil, vim.fn.getcwd())
			end,
			desc = "Open yazi in cwd",
		},
	},
	opts = {
		-- if you want to replace netrw entirely with yazi
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
	},
}
