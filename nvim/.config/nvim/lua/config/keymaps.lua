-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- split
vim.keymap.set("n", "<leader>h", "<cmd>vsplit<cr>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>v", "<cmd>split<cr>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "New tab" })

-- diagnostics popup (like K but for errors/warnings)
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic popup" })

-- formatting
vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { desc = "Format" })

-- close float windows with q
vim.keymap.set("n", "<Esc>", function()
	vim.cmd.nohlsearch()
	local win = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(win).relative ~= "" then
		vim.api.nvim_win_close(win, false)
	else
		vim.fn.feedkeys("q", "n")
	end
end, { desc = "Close float / q" })
