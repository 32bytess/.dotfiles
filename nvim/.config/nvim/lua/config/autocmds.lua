local lsp = require("plugins.lsp")._funcs

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		lsp.on_attach(ev.buf)
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
