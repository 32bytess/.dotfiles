return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-github.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")

			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"^%.git/",
						"%.png",
						"%.jpg",
						"%.jpeg",
						"%.gif",
						"%.webp",
						"%.avif",
						"%.ico",
						"%.svg",
						"%.bmp",
						"%.tiff",
						"%.pdf",
						"%.zip",
						"%.tar",
						"%.gz",
						"%.mp4",
						"%.mp3",
						"%.wav",
						"%.ttf",
						"%.woff",
						"%.woff2",
					},
				},
			})

			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					find_command = { "fd", "--type", "f", "--hidden", "--follow" },
				})
			end, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep({ additional_args = { "--hidden" } })
			end, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fd", function()
				builtin.find_files({
					find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
				})
			end, { desc = "Telescope find dirs" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })

			-- git
			vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
			vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "Git Log" })
			vim.keymap.set("n", "<leader>gL", builtin.git_bcommits, { desc = "Git Log (buffer)" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
			vim.keymap.set("n", "<leader>gD", builtin.git_status, { desc = "Git Diff (files)" })
			vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" })
			vim.keymap.set("n", "<leader>gf", builtin.git_bcommits, { desc = "Git Log File" })

			-- gh
			require("telescope").load_extension("gh")
			local gh = require("telescope").extensions.gh
			vim.keymap.set("n", "<leader>gi", function()
				gh.issues({ state = "open" })
			end, { desc = "GitHub Issues (open)" })
			vim.keymap.set("n", "<leader>gI", function()
				gh.issues({ state = "all" })
			end, { desc = "GitHub Issues (all)" })
			vim.keymap.set("n", "<leader>gp", function()
				gh.pull_request({ state = "open" })
			end, { desc = "GitHub Pull Requests (open)" })
			vim.keymap.set("n", "<leader>gP", function()
				gh.pull_request({ state = "all" })
			end, { desc = "GitHub Pull Requests (all)" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
