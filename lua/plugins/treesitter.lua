return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- Treesitter must not be lazy-loaded in the new version
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local supported_languages = {
			"lua", "vim", "vimdoc", "query", "dart", "python",
			"dockerfile", "yaml", "bash", "json", "html",
			"css", "javascript", "sql", "markdown", "markdown_inline",
		}
		-- 1. Global Settings
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
			auto_install = true,
		})
		-- 2. Bulk Install Parsers (Asynchronous)
		ts.install(supported_languages)
		-- 3. Enable Highlighting	
		vim.api.nvim_create_autocmd("FileType", {
			pattern = supported_languages,
			callback = function()
				local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
				if lang then
					vim.treesitter.start()
				end
			end,
		})
	end,
}
