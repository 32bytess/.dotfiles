vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {vim.api.nvim_get_runtime_file("", true)},
			diagnostics = { globals = { "vim","require" } },
		},
	},
})

vim.lsp.config("*", {
	on_attach = require("config.lsp_attach").on_attach,
})

vim.lsp.enable("lua_ls")

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls","stylua"},
			})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.lib",
			"rafamadriz/friendly-snippets",
		},
		build = function()
			require("blink.cmp").build():wait(60000)
		end,
		opts = {
			keymap = { preset = "default" },
			completion = { documentation = { auto_show = false } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust" },
		},
	},
}
