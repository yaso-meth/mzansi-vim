return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			vim.opt.termguicolors = true
			vim.api.nvim_create_autocmd({ "TextChanged", "BufWinEnter" }, {
				pattern = "*__FLUTTER_DEV_LOG__*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()

					if vim.bo[buf].filetype == "log" or vim.fn.bufname(buf):match("flutter%-dev%.log") then
						vim.cmd("normal! G")
					end
				end,
			})

			require("flutter-tools").setup({
				ui = {
					border = "rounded",
					notification_style = "plugin",
				},
				decorations = {
					statusline = {
						app_version = true,
						device = true,
					}
				},
				lsp = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					on_attach = function(client, bufnr)
						client.server_capabilities.semanticTokensProvider = nil
						client.server_capabilities.documentOnTypeFormattingProvider = nil
						-- client.server_capabilities.diagnosticProvider = nil
					end,
					flags = {
						debounce_text_changes = 150, -- milliseconds
					},
					settings = {
						showTodos = true,
						completeFunctionCalls = false,
						renameFilesWithClasses = "prompt",
						enableSnippets = true,
						updateImportsOnRename = true,
					},
				},
				widget_guides = {
					enabled = true,
				},
				closing_tags = {
					enabled = false,
				},
				dev_log = {
					enabled = true,
					notify_errors = false,
					open_cmd = "vertical rightbelow vsplit",
				},
			})


			-- Custom Shorthand Commands
			local user_command = vim.api.nvim_create_user_command

			-- Simple Aliases
			-- user_command("FRun", "FlutterRun", {})
			-- user_command("FRun", "FlutterRun --color", {})
			user_command("FRun", "FlutterRun --web-port 1995", {})

			user_command("FReload", "FlutterReload", {})
			user_command("FRestart", "FlutterRestart", {})
			user_command("FQuit", "FlutterQuit", {})
			user_command("FDevices", "FlutterDevices", {})
			user_command("FEmulators", "FlutterEmulators", {})
			user_command("FLogs", "FlutterLogToggle", {})
			user_command("FLogsClear", "FlutterLogClear", {})
			user_command("FPubGet", "FlutterPubGet", {})
			user_command("FDevToolsStart", "FlutterDevTools", {})
			user_command("FDevToolsOpen", "FlutterOpenDevTools", {})
			user_command("FBuild", "split | term dart run build_runner build", {})
			user_command("FWatch", "split | term dart run build_runner watch", {})
			user_command("FClean", "split | term flutter clean", {})
			-- Target-specific Run Command
			user_command("FRunT", function(opts)
				vim.cmd("FlutterRun --web-port 1995 --target=" .. opts.args)
			end, {
				nargs = 1,
				complete = "file",
				desc = "Run Flutter with a specific target file",
			})
		end,
	},
}
