return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
		},
		float = {
			padding = 2,
			border = "rounded",
		},
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},
	},
}
