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
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "log",
				callback = function(ev)
					if not vim.fn.bufname(ev.buf):match("FLUTTER_DEV_LOG") then
						return
					end

					if vim.b[ev.buf].flutter_autoscroll_attached then
						return
					end
					vim.b[ev.buf].flutter_autoscroll_attached = true

					local pinned = true

					vim.api.nvim_create_autocmd("WinScrolled", {
						callback = function()
							local wins = vim.fn.win_findbuf(ev.buf)
							for _, win in ipairs(wins) do
								local info = vim.fn.getwininfo(win)[1]
								if info then
									pinned = info.botline >= vim.api.nvim_buf_line_count(ev.buf)
								end
							end
						end,
					})

					vim.api.nvim_buf_attach(ev.buf, false, {
						on_lines = function()
							if not pinned then
								return
							end
							vim.schedule(function()
								local line_count = vim.api.nvim_buf_line_count(ev.buf)
								local wins = vim.fn.win_findbuf(ev.buf)
								for _, win in ipairs(wins) do
									pcall(vim.api.nvim_win_set_cursor, win, { line_count, 0 })
								end
							end)
						end,
						on_detach = function()
							vim.b[ev.buf].flutter_autoscroll_attached = nil
						end,
					})
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
						-- client.server_capabilities.documentOnTypeFormattingProvider = nil
						-- client.server_capabilities.diagnosticProvider = nil
					end,
					flags = {
						debounce_text_changes = 150, -- milliseconds
					},
					settings = {
						showTodos = false,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt",
						enableSnippets = true,
						updateImportsOnRename = true,
						analysisExcludedFolders = {
							vim.fn.expand("$HOME/.pub-cache"),
							vim.fn.expand("$HOME/Git/flutter"),
							vim.fn.getcwd() .. "/android",
							vim.fn.getcwd() .. "/app",
							vim.fn.getcwd() .. "/build",
							vim.fn.getcwd() .. "/build-dir",
							vim.fn.getcwd() .. "/flatpak",
							vim.fn.getcwd() .. "/ios",
							vim.fn.getcwd() .. "/linux",
							vim.fn.getcwd() .. "/macos",
							vim.fn.getcwd() .. "/repo",
							vim.fn.getcwd() .. "/web",
							vim.fn.getcwd() .. "/windows",
							vim.fn.getcwd() .. "/.dart_tool",
							vim.fn.getcwd() .. "/.flatpak-builder",
							vim.fn.getcwd() .. "/.idea",
						},
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
			user_command("FLogs", "FlutterLogToggle", {})
			user_command("FLspRestart", "lsp restart", {})
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
