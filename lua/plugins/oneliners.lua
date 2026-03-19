return {
	{
		-- Git Plugin
		'tpope/vim-fugitive',
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
			vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
		end,
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},

}
