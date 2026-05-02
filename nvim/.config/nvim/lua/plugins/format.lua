return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			dart = { "dart_format" },
		},
		format_on_save = {
			timeout_ms = 200,
			lsp_fallback = true,
		},
	},
}
