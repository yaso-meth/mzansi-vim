vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<leader>;", ":Dashboard<CR>", { desc = "Return to Dashboard", silent = true })
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
        nowait = true,        desc = "Return to Dashboard" 
      })
    end)
  end,
})
