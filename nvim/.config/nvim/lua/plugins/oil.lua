return {
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {
			diagnostic_symbols = {
				error = "E",
				warn = "W",
				info = "I",
				hint = "H",
			},
		},
	},
	{
		"malewicz1337/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
		config = function()
			require("oil-git").setup({
				debounce_ms = 50,
				show_file_highlights = true,
				show_directory_highlights = true,
				show_file_symbols = true,
				show_directory_symbols = true,
				symbols = {
					file = {
						added = "+",
						modified = "~",
						renamed = "->",
						deleted = "D",
						copied = "C",
						conflict = "!",
						untracked = "?",
						ignored = "o",
					},
					directory = {
						added = "*",
						modified = "*",
						renamed = "*",
						deleted = "*",
						copied = "*",
						conflict = "!",
						untracked = "*",
						ignored = "o",
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			local oil = require("oil")
			oil.setup({
				default_file_explorer = true,
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				lsp_file_methods = {
					enabled = true,
					timeout_ms = 1000,
					autosave_changes = false,
				},
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, bufnr)
						local dir = require("oil").get_current_dir(bufnr)
						if not dir then return false end
						vim.fn.system({ "git", "check-ignore", "-q", dir .. name })
						return vim.v.shell_error == 0
					end,
				},
				float = {
					padding = 2,
					border = "rounded",
				},
			})
			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil" })
			vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "flaot" })
		end,
	},
}
