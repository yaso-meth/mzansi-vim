return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	opts = function()
		local logo = [[
 ███╗   ███╗███████╗ █████╗ ███╗   ██╗███████╗██╗██╗   ██╗██╗███╗   ███╗
 ████╗ ████║╚══███╔╝██╔══██╗████╗  ██║██╔════╝██║██║   ██║██║████╗ ████║
 ██╔████╔██║  ███╔╝ ███████║██╔██╗ ██║███████╗██║██║   ██║██║██╔████╔██║
 ██║╚██╔╝██║ ███╔╝  ██╔══██║██║╚██╗██║╚════██║██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚═╝ ██║███████╗██║  ██║██║ ╚████║███████║██║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]]

		logo = string.rep("\n", 8) .. logo .. "\n\n"

		local opts = {
			theme = "doom",
			config = {
				header = vim.split(logo, "\n"),
				center = {
					-- Aligned to Mzansi Vim Essential Keybindings
					{ icon = "󰉓 ", desc = " File Explorer    ", key = "cd", action = "Explore" },
					{ icon = " ", desc = " Find Files       ", key = "ff", action = "Telescope find_files" },
					{ icon = " ", desc = " Live Grep        ", key = "fg", action = "Telescope live_grep" },
					{
						icon = "󰛢 ",
						desc = " Harpoon Menu     ",
						key = "e",
						action = function()
							local harpoon = require("harpoon")
							harpoon.ui:toggle_quick_menu(harpoon:list())
						end
					},
					{ icon = "󱗘 ", desc = " Harpoon Search   ", key = "fl", action = "Telescope harpoon marks" },
					{ icon = "󰒲 ", desc = " Lazy Manager     ", key = "z", action = "Lazy" },
					{ icon = "ⓘ ", desc = " Help Tags        ", key = "fh", action = "Telescope help_tags" },
					{ icon = " ", desc = " Quit             ", key = "q", action = "qa" },
				},
				-- footer = { vim.fn.strftime("%Y-%m-%d %H:%M:%S") .. " • Mzansi Vim Kickstart" },
				footer = { "Let's Keep Working Hard Mzansi" },
			},
		}

		return opts
	end,
	dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
