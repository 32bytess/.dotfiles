return {
	{
		"nvim-flutter/flutter-tools.nvim",
		ft = { "dart" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			require("flutter-tools").setup({
				widget_guides = {
					enabled = true,
				},
				ui = {
					border = "rounded",
					notification_style = "plugin",
				},
				lsp = {
					on_attach = require("custom.lsp_attach").on_attach,
					color = {
						enabled = true,
						background = true,
						foreground = false,
					},
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						updateImportsOnRename = true,
						enableSnippets = true,
					},
					capabilities = require("blink.cmp").get_lsp_capabilities(),
				},
			})
		end,
	},
}
