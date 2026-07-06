return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local supported_languages = {
			"lua", "vim", "vimdoc", "query", "dart", "python",
			"dockerfile", "yaml", "bash", "json", "html",
			"css", "javascript", "sql", "markdown", "markdown_inline",
		}
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		local already_installed = require("nvim-treesitter.config").get_installed()
		local parsers_to_install = {}

		for _, lang in ipairs(supported_languages) do
			if not vim.tbl_contains(already_installed, lang) then
				table.insert(parsers_to_install, lang)
			end
		end

		if #parsers_to_install > 0 then
			ts.install(parsers_to_install)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = supported_languages,
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
