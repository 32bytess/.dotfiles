vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = { "*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.svg", "*.pdf" },
	callback = function(ev)
		vim.fn.jobstart({ "xdg-open", ev.file }, { detach = true })
		vim.schedule(function()
			vim.api.nvim_buf_delete(ev.buf, { force = true })
		end)
	end,
})
