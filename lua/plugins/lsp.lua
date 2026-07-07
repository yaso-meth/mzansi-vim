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

			-- 1. Global capabilities registered natively for all servers
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.env.VIMRUNTIME,
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
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

			for _, server_name in ipairs(servers) do
				if server_name ~= "dartls" then
					vim.lsp.enable(server_name)
				end
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, opts)

					-- Diagnostics
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
					vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
					vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, opts)

					-- Explicit formatting configuration
					vim.keymap.set("n", "<leader>af", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = ev.buf, desc = "Format file" })

					-- Safe Format on Save scoped specifically to current buffer
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = ev.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = ev.buf, async = false })
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
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", keyword_length = 2 },
					{ name = "luasnip",  keyword_length = 2 },
					{
						name = "buffer",
						keyword_length = 2,
						option = {
							get_bufnrs = function()
								return { vim.api.nvim_get_current_buf() }
							end
						}
					},
					{ name = "path" },
				}),
			})
		end,
	},
}
