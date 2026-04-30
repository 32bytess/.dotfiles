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

-- ADB WiFi QR code pairing (floating terminal, closes on exit)
vim.keymap.set("n", "<leader>aa", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.5)
	local height = 20
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " ADB WiFi Pair ",
		title_pos = "center",
	})
	vim.fn.termopen("adb-wifi", {
		on_exit = function()
			vim.api.nvim_win_close(win, true)
		end,
	})
	vim.cmd("startinsert")
end, { desc = "ADB WiFi QR pair" })

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
