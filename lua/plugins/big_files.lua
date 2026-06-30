return {
	{
		"LunarVim/bigfile.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Fallback size if the function doesn't intercept it
			filesize = 2,
			-- Use a detection function to unconditionally catch generated files
			pattern = function(bufnr, _)
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				if buf_name:match("%.g%.dart$") or buf_name:match("hive_registrar%.g%.dart$") then
					-- 1. Hard-disable Autopairs for this specific buffer
					vim.api.nvim_buf_set_var(bufnr, "autopairs_enabled", false)

					-- 2. Prevent the Copilot server from attaching and tracking
					vim.api.nvim_buf_set_var(bufnr, "copilot_enabled", 0)
					return true
				end
			end,
			features = {
				"indent_blankline", -- Disables heavy indentation lines
				"lsp",  -- Strips LSP diagnostics and semantic tokens for this buffer
				"treesitter", -- Completely disables treesitter parsing/highlighting
				"syntax", -- Drops standard heavy syntax engines
				"matchparen", -- Stops Neovim from trying to match deeply nested brackets
			},
		},
		config = function(_, opts)
			require("bigfile").setup(opts)
		end,
	},
}
