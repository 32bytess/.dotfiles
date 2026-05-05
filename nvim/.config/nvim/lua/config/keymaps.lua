-- ─── UI / Navigation ────────────────────────────────────────────────────────

-- Clear search highlight; close float window if currently focused
vim.keymap.set("n", "<Esc>", function()
	vim.cmd.nohlsearch()
	local win = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(win).relative ~= "" then
		vim.api.nvim_win_close(win, false)
	end
end, { desc = "Close float / clear highlight", silent = true })

-- ─── Diagnostics ────────────────────────────────────────────────────────────

vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic popup", silent = true })

-- ─── Formatting ─────────────────────────────────────────────────────────────

vim.keymap.set({ "n", "v" }, "<leader>gf", function()
	require("custom.smart_format").smart_format()
end, { desc = "Format", silent = true })

-- ─── Terminal ───────────────────────────────────────────────────────────────

local term = require("custom.term_float").new(vim.o.shell)
vim.keymap.set("n", "<leader>tt", term.toggle, { desc = "Toggle terminal float", silent = true })

-- ─── Mobile / ADB ───────────────────────────────────────────────────────────

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
end, { desc = "ADB WiFi QR pair", silent = true })
