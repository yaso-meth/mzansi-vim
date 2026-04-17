return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
			"m00qek/baleia.nvim",
		},
		config = function()
			vim.opt.termguicolors = true
			vim.env.FLUTTER_FORCE_COLOR = "1"

			local baleia = require("baleia").setup({
				strip_ansi_codes = true,
			})



			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "*__FLUTTER_DEV_LOG__*",
				callback = function(args)
					local bufnr = args.buf

					if not vim.bo[bufnr].modifiable then
						vim.bo[bufnr].modifiable = true
					end

					baleia.automatically(bufnr)
				end,
			})

			vim.api.nvim_create_autocmd("OptionSet", {
				pattern = "modifiable",
				callback = function(args)
					local bufnr = args.buf
					if not vim.bo[bufnr].modifiable then
						vim.bo[bufnr].modifiable = true
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
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						updateImportsOnRename = true,
					},
				},
				widget_guides = {
					enabled = true,
				},
				dev_log = {
					enabled = true,
					notify_errors = false,
					open_cmd = "vertical rightbelow vsplit",
				},
			})

			-- Some Flutter log lines include ANSI start codes but no explicit reset.
			-- Baleia keeps style state across lines, so missing reset can "bleed"
			-- colors into following lines. Normalize those log lines first.
			do
				local ok, flutter_log = pcall(require, "flutter-tools.log")
				if ok and flutter_log and type(flutter_log.log) == "function" then
					local raw_log = flutter_log.log
					local ansi_pattern = "\27%[[0-9;]*m"
					local ansi_reset = "\27[0m"

					flutter_log.log = function(data)
						if type(data) == "string" then
							local has_ansi = data:find(ansi_pattern) ~= nil
							local has_reset = data:find("\27%[0m") ~= nil
							if has_ansi and not has_reset then
								data = data .. ansi_reset
							end
						end
						raw_log(data)
					end
				end
			end

			-- Custom Shorthand Commands
			local user_command = vim.api.nvim_create_user_command

			-- Simple Aliases
			-- user_command("FRun", "FlutterRun", {})
			-- user_command("FRun", "FlutterRun --color", {})
			user_command("FRun", "FlutterRun --color", {})

			user_command("FReload", "FlutterReload", {})
			user_command("FRestart", "FlutterRestart", {})
			user_command("FQuit", "FlutterQuit", {})
			user_command("FDevices", "FlutterDevices", {})
			user_command("FEmulators", "FlutterEmulators", {})
			user_command("FLogs", "FlutterLogToggle", {})
			user_command("FLogsClear", "FlutterLogClear", {})

			-- Target-specific Run Command
			user_command("FRunT", function(opts)
				vim.cmd("FlutterRun --color --target=" .. opts.args)
			end, {
				nargs = 1,
				complete = "file",
				desc = "Run Flutter with a specific target file",
			})
		end,
	},
}
