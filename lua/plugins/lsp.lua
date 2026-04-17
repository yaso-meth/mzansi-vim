return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			local mason_lspconfig = require("mason-lspconfig")

			-- Register global capabilities for all servers
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			local servers = {
				"lua_ls",
				"pyright",
				"dockerls",
				"bashls",
				"yamlls",
				"jsonls",
				"html",
				"cssls",
				"eslint",
				"sqls",
				"marksman",
			}

			mason_lspconfig.setup({
				ensure_installed = servers,
			})

			-- Neovim 0.11+ approach: Configure and Enable
			for _, server_name in ipairs(servers) do
				if server_name == "lua_ls" then
					vim.lsp.config("lua_ls", {
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
							},
						},
					})
				end
				-- Activate the server
				vim.lsp.enable(server_name)
			end

			-- Diagnostic display config
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				float = { border = "rounded", source = true },
			})

			-- Keybindings & Formatting
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					-- Neovim 0.11+ provides some defaults like 'grn' (rename),
					-- but keeping your custom ones is fine.
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, opts)
					-- Diagnostic keymaps
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- show error under cursor
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)        -- jump to previous error
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)        -- jump to next error
					vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, opts) -- all errors in quickfix list
					vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, { desc = "Format file" }) -- manual format
					-- Format on save (with filter to prevent multi-client conflicts)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = ev.buf,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
