local M = {}

function M.new(cmd)
	local buf = nil

	local function open(focus)
		if not (buf and vim.api.nvim_buf_is_valid(buf)) then
			buf = vim.api.nvim_create_buf(false, false)
		end
		local width = math.floor(vim.o.columns * 0.9)
		local height = math.floor(vim.o.lines * 0.85)
		vim.api.nvim_open_win(buf, focus, {
			relative = "editor",
			width = width,
			height = height,
			row = math.floor((vim.o.lines - height) / 2),
			col = math.floor((vim.o.columns - width) / 2),
			style = "minimal",
			border = "rounded",
		})
		if vim.bo[buf].buftype ~= "terminal" then
			vim.api.nvim_buf_call(buf, function()
				vim.fn.termopen(cmd)
			end)
			vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit terminal mode" })
			vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit terminal mode" })
		end
	end

	local function toggle()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if buf and vim.api.nvim_win_get_buf(win) == buf then
				vim.api.nvim_win_close(win, false)
				return
			end
		end
		open(true)
		vim.cmd("startinsert")
	end

	local function send_selection()
		local file = vim.fn.expand("%:p")
		local start_line = vim.fn.line("'<")
		local end_line = vim.fn.line("'>")

		local float_open = false
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if buf and vim.api.nvim_win_get_buf(win) == buf then
				float_open = true
				break
			end
		end
		if not float_open then
			open(false)
		end

		local job_id = vim.b[buf].terminal_job_id
		if job_id then
			vim.fn.chansend(job_id, "@" .. file .. ":" .. start_line .. "-" .. end_line .. " ")
		end

		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if buf and vim.api.nvim_win_get_buf(win) == buf then
				vim.api.nvim_set_current_win(win)
				vim.cmd("startinsert")
				break
			end
		end
	end

	return { toggle = toggle, send_selection = send_selection }
end

return M
