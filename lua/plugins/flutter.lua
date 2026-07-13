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

			local function run_flutter_with_mode(extra_args)
				extra_args = extra_args or "--target=lib/main.dart"

				-- 1. Get devices asynchronously so we never block the UI thread
				--    (blocking here is what causes queued terminal input to get
				--    flushed as garbage text into vim.ui.select afterwards)
				vim.system({ "flutter", "devices", "--machine" }, { text = true }, function(obj)
					vim.schedule(function()
						if obj.code ~= 0 or not obj.stdout or obj.stdout == "" then
							vim.notify("Failed to query flutter devices, falling back", vim.log.levels.WARN)
							vim.cmd("FlutterRun " .. extra_args)
							return
						end

						-- 2. Extract just the JSON array in case of stray stdout noise
						local json_str = obj.stdout:match("%[.*%]")
						if not json_str then
							vim.cmd("FlutterRun " .. extra_args)
							return
						end

						local success, devices = pcall(vim.json.decode, json_str)
						if not success or not devices or #devices == 0 then
							vim.cmd("FlutterRun " .. extra_args)
							return
						end

						-- 3. Map devices into readable strings for the selection prompt
						local options = {}
						local device_map = {}
						for _, dev in ipairs(devices) do
							local platform = dev.targetPlatform or "unknown"
							local display_str = string.format("%s (%s) • %s", dev.name, platform, dev.id)
							table.insert(options, display_str)
							device_map[display_str] = dev
						end

						-- 4. Open the device choice menu
						vim.ui.select(options, {
							prompt = "Flutter run (Choose a device)",
						}, function(selected_display)
							if not selected_display then return end
							local selected_device = device_map[selected_display]
							local platform = selected_device.targetPlatform or ""

							-- 5. Intercept if it's a web target
							if selected_device.id == "chrome"
								or selected_device.id == "web-server"
								or platform:match("web") then
								vim.ui.select({ "1. JavaScript (Standard)", "2. WebAssembly (WASM)" }, {
									prompt = "Select Web Compilation Mode:",
								}, function(mode_choice)
									if not mode_choice then return end
									local web_flags = " --web-port 1995"
									if mode_choice:match("WASM") then
										web_flags = web_flags .. " --wasm"
									end
									vim.cmd(string.format(
										"FlutterRun --device-id=%s %s %s",
										selected_device.id, web_flags, extra_args
									))
								end)
							else
								-- 6. Native compilation (Linux, Android, etc.)
								vim.cmd(string.format(
									"FlutterRun --device-id=%s %s",
									selected_device.id, extra_args
								))
							end
						end)
					end)
				end)
			end
			user_command("FRun", function()
				run_flutter_with_mode()
			end, {})
			user_command("FRunT", function(opts)
				run_flutter_with_mode(" --target=" .. opts.args)
			end, {
				nargs = 1,
				complete = "file",
				desc = "Run Flutter with a specific target file",
			})
			-- user_command("FRunT", function(opts)
			-- 	vim.cmd("FlutterRun --target=" .. opts.args)
			-- end, {
			-- 	nargs = 1,
			-- 	complete = "file",
			-- 	desc = "Run Flutter with a specific target file",
			-- })
			-- user_command("FRun", "FlutterRun", {})
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
		end,
	},
}
