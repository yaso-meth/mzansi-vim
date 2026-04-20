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
			-- vim.env.FLUTTER_FORCE_COLOR = "1"

			-- Auto scroll & Color logs when new logs appear
			vim.api.nvim_create_autocmd({ "TextChanged", "BufWinEnter" }, {
				pattern = "*__FLUTTER_DEV_LOG__*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()

					-- Auto-scroll logic
					if vim.bo[buf].filetype == "log" or vim.fn.bufname(buf):match("flutter%-dev%.log") then
						local win = vim.api.nvim_get_current_win()
						local last_line = vim.api.nvim_buf_line_count(buf)
						if vim.api.nvim_get_mode().mode ~= 'i' then
							vim.api.nvim_win_set_cursor(win, { last_line, 0 })
						end
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


			-- Custom Shorthand Commands
			local user_command = vim.api.nvim_create_user_command

			-- Simple Aliases
			-- user_command("FRun", "FlutterRun", {})
			-- user_command("FRun", "FlutterRun --color", {})
			user_command("FRun", "FlutterRun", {})

			user_command("FReload", "FlutterReload", {})
			user_command("FRestart", "FlutterRestart", {})
			user_command("FQuit", "FlutterQuit", {})
			user_command("FDevices", "FlutterDevices", {})
			user_command("FEmulators", "FlutterEmulators", {})
			user_command("FLogs", "FlutterLogToggle", {})
			user_command("FLogsClear", "FlutterLogClear", {})

			-- Target-specific Run Command
			user_command("FRunT", function(opts)
				vim.cmd("FlutterRun --target=" .. opts.args)
			end, {
				nargs = 1,
				complete = "file",
				desc = "Run Flutter with a specific target file",
			})
		end,
	},
}
