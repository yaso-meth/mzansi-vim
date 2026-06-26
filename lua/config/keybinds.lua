vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<leader>;", ":Dashboard<CR>", { desc = "Return to Dashboard", silent = true })
-- Copy visual selection to system clipboard using Leader + y
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
-- Paste from system clipboard using Leader + p
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(event)
		vim.schedule(function()
			vim.keymap.set("n", "<Esc>", function()
				vim.cmd("enew")
				vim.cmd("Dashboard")
			end, {
				buffer = event.buf,
				nowait = true,
				desc = "Return to Dashboard"
			})
		end)
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(event)
		vim.schedule(function()
			vim.keymap.set("n", "<leader>;", function()
				vim.cmd("enew")
				vim.cmd("Dashboard")
			end, {
				buffer = event.buf,
				nowait = true,
				desc = "Return to Dashboard"
			})
		end)
	end,
})
