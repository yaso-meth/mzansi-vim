return {
	'windwp/nvim-autopairs',
	event = 'InsertEnter',
	opts = {
		fast_wrap = {},
	},
	config = function(_, opts)
		-- Initialize autopairs with your choices
		require('nvim-autopairs').setup(opts)

		-- Safely hook into cmp if it's already available
		local cmp_status, cmp = pcall(require, 'cmp')
		if cmp_status then
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end
	end,
}
