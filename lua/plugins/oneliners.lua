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
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				check_ts = true,
				ts_config = {
					lua = { "string" },
					dart = { "string_literal" }
				}
			})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local pcall_cmp, cmp = pcall(require, "cmp")
			if pcall_cmp then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end
	},

}
