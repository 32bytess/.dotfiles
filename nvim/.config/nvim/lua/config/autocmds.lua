vim.filetype.add({ extension = { jsonl = "json" } })

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd.checktime()
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = { "*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.svg", "*.pdf" },
	callback = function(ev)
		vim.fn.jobstart({ "xdg-open", ev.file }, { detach = true })
		vim.schedule(function()
			vim.api.nvim_buf_delete(ev.buf, { force = true })
		end)
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
