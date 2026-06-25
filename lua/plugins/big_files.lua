return {
	{
		"LunarVim/bigfile.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			filesize = 0.01,                          -- 10 KiB (your hive_adapters.g.dart sits right around here)
			pattern = { "*.g.dart", "hive_registrar.g.dart" }, -- Force override on generated Dart files
			features = {
				"indent_blankline",                   -- Disables heavy indentation lines
				"lsp",                                -- Strips LSP diagnostics and semantic tokens for this buffer
				"treesitter",                         -- Completely disables treesitter parsing/highlighting
				"syntax",                             -- Drops standard heavy syntax engines
				"matchparen",                         -- Stops Neovim from trying to match deeply nested brackets
			},
		},
		config = function(_, opts)
			require("bigfile").setup(opts)
		end,
	},
}
