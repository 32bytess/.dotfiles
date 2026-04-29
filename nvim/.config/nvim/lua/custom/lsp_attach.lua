local M = {}

M.on_attach = function(_, buf)
	local opts = { buffer = buf }
	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, vim.tbl_extend("force", opts, { desc = desc }))
	end
	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gD", vim.lsp.buf.declaration, "Go to declaration")
	map("gr", vim.lsp.buf.references, "References")
	map("gi", vim.lsp.buf.implementation, "Go to implementation")
	map("K", vim.lsp.buf.hover, "Hover docs")
	map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("<leader>rn", vim.lsp.buf.rename, "Rename")
	map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
	map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
	map("]d", vim.diagnostic.goto_next, "Next diagnostic")
end

return M
