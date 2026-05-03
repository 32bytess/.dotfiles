local gemini_buf = nil

local function open_float(focus)
	if not (gemini_buf and vim.api.nvim_buf_is_valid(gemini_buf)) then
		gemini_buf = vim.api.nvim_create_buf(false, false)
	end
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.85)
	vim.api.nvim_open_win(gemini_buf, focus, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	if vim.bo[gemini_buf].buftype ~= "terminal" then
		vim.api.nvim_buf_call(gemini_buf, function()
			vim.fn.termopen("gemini")
		end)
		vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = gemini_buf, desc = "Exit terminal mode" })
	end
end

local function toggle_float()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if gemini_buf and vim.api.nvim_win_get_buf(win) == gemini_buf then
			vim.api.nvim_win_close(win, false)
			return
		end
	end
	open_float(true)
	vim.cmd("startinsert")
end

local function send_selection()
	local file = vim.fn.expand("%:p")
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	local float_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if gemini_buf and vim.api.nvim_win_get_buf(win) == gemini_buf then
			float_open = true
			break
		end
	end
	if not float_open then
		open_float(false)
	end

	local job_id = vim.b[gemini_buf].terminal_job_id
	if job_id then
		vim.fn.chansend(job_id, "@" .. file .. ":" .. start_line .. "-" .. end_line .. " ")
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if gemini_buf and vim.api.nvim_win_get_buf(win) == gemini_buf then
			vim.api.nvim_set_current_win(win)
			vim.cmd("startinsert")
			break
		end
	end
end

return {
	{
		"gemini-cli",
		dir = vim.fn.stdpath("config"),
		config = function()
			vim.keymap.set("n", "<leader>ig", toggle_float, { desc = "Toggle Gemini CLI float" })
			vim.keymap.set("v", "<leader>ia", send_selection, { desc = "Add Selection to Gemini" })
		end,
	},
}
