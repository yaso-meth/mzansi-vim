return {
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				check_ts = false,
				map_cr = false,
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
