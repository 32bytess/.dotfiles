vim.filetype.add({ extension = { jsonl = "json", jsonc = "json" } })

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd.checktime()
		end
	end,
})

local _sigusr1 = (vim.uv or vim.loop).new_signal()
_sigusr1:start("sigusr1", function()
	vim.schedule(function()
		require("theme").setup()
		vim.cmd("redraw!")
	end)
end)

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "**/lua/theme/colors.lua",
	callback = function()
		vim.opt_local.swapfile = false
		vim.opt_local.undofile = false
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
