local M = {}

function M.smart_format()
	if vim.bo.filetype == "markdown" then
		return
	end
	local has_formatter = false
	local ok, conform = pcall(require, "conform")
	if ok then
		local formatters = conform.list_formatters(0)
		if #formatters > 0 then
			conform.format({ lsp_fallback = true })
			has_formatter = true
		end
	end

	if not has_formatter then
		local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
		local clients = get_clients({ bufnr = 0, method = "textDocument/formatting" })
		if #clients > 0 then
			vim.lsp.buf.format()
			has_formatter = true
		end
	end

	if not has_formatter then
		local view = vim.fn.winsaveview()
		if vim.api.nvim_get_mode().mode:lower():find("v") then
			vim.cmd("normal! =")
		else
			vim.cmd("silent! keepjumps normal! gg=G")
		end
		vim.fn.winrestview(view)
	end
end

return M
