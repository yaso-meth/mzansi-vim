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
			-- We no longer need: local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

			-- Neovim 0.11+ approach: Use vim.lsp.config
			for _, server_name in ipairs(servers) do
				local config = {
					capabilities = capabilities,
				}

				if server_name == "lua_ls" then
					config.settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					}
				end

				-- Enable the server configuration natively
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end

			-- Diagnostic display config
			vim.diagnostic.config({
				virtual_text = true, -- show error inline at end of line
				signs = true,
				underline = true,
				update_in_insert = false, -- only update after leaving insert mode
				float = {
					border = "rounded",
					source = true, -- shows which LSP reported the error
				},
			})

			-- Keybindings (unchanged)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					-- Diagnostic keymaps
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- show error under cursor
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)        -- jump to previous error
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)        -- jump to next error
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts) -- all errors in quickfix list
					vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, { desc = "Format file" }) -- manual format

					-- Format on save
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
		"nvim-flutter/flutter-tools.nvim",
		lazy = false, -- Load on startup to ensure it handles dartls correctly
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- Optional but highly recommended for better UI
		},
		config = function()
			require("flutter-tools").setup({
				lsp = {
					-- Pass your existing capabilities to the flutter-tools LSP config
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					-- You can add specific dartls settings here if needed
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
					},
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip", -- Snippet engine is usually required by cmp configs
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
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
