local lazygit_buf = nil

local function open_float()
	if not (lazygit_buf and vim.api.nvim_buf_is_valid(lazygit_buf)) then
		lazygit_buf = vim.api.nvim_create_buf(false, false)
	end
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.85)
	vim.api.nvim_open_win(lazygit_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	if vim.bo[lazygit_buf].buftype ~= "terminal" then
		vim.api.nvim_buf_call(lazygit_buf, function()
			vim.fn.termopen("lazygit", {
				on_exit = function()
					lazygit_buf = nil
				end,
			})
		end)
		vim.keymap.set("t", "q", function()
			vim.api.nvim_win_close(0, false)
		end, { buffer = lazygit_buf, desc = "Close lazygit float" })
	end
	vim.cmd("startinsert")
end

local function toggle_float()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if lazygit_buf and vim.api.nvim_win_get_buf(win) == lazygit_buf then
			vim.api.nvim_win_close(win, false)
			return
		end
	end
	open_float()
end

vim.keymap.set("n", "<leader>gg", toggle_float, { desc = "Toggle Lazygit float" })

return {}
