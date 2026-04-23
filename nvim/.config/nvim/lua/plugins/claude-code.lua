local claude_buf = nil

local function open_float(focus)
	if not (claude_buf and vim.api.nvim_buf_is_valid(claude_buf)) then
		claude_buf = vim.api.nvim_create_buf(false, false)
	end
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.85)
	vim.api.nvim_open_win(claude_buf, focus, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	if vim.bo[claude_buf].buftype ~= "terminal" then
		vim.fn.termopen("claude")
		vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = claude_buf, desc = "Exit terminal mode" })
	end
end

local function toggle_float()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if claude_buf and vim.api.nvim_win_get_buf(win) == claude_buf then
			vim.api.nvim_win_close(win, false)
			return
		end
	end
	open_float(true)
	vim.cmd("startinsert")
end

local function send_selection()
	local float_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if claude_buf and vim.api.nvim_win_get_buf(win) == claude_buf then
			float_open = true
			break
		end
	end
	if not float_open then
		open_float(false)
	end
	vim.cmd("ClaudeCodeSend")
end

return {
	"coder/claudecode.nvim",
	opts = {},
	_funcs = {
		toggle_float = toggle_float,
		send_selection = send_selection,
	},
}
