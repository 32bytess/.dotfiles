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
