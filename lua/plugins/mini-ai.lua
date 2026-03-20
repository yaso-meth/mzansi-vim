return {
	"echasnovski/mini.ai",
	version = "*",
	config = function()
		require("mini.ai").setup({
			search_method = "next",
		})
	end,
}
