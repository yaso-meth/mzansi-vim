return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	-- event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
			highlight = {
				enable = true,
				-- additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"dart",
				"python",
				"dockerfile",
				"yaml",
				"bash",
				"json",
				"html",
				"css",
				"javascript",
				"sql",
				"markdown",
				"markdown_inline",
			},
		})
	end,
}
