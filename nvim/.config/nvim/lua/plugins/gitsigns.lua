return {
	"lewis6991/gitsigns.nvim",
	event = "BufRead",
	config = function()
		require("gitsigns").setup({
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "Reset Hunk" })

				map("v", "<leader>ghs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Hunk" })

				map("v", "<leader>ghr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Hunk" })

				map("n", "<leader>ghS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>ghR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>ghp", function()
					local hunks = gitsigns.get_hunks(bufnr)
					if not hunks or #hunks == 0 then
						return
					end
					local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
					local hunk = nil
					for _, h in ipairs(hunks) do
						local s = h.added.start
						local e = s + math.max(h.added.count - 1, 0)
						if h.added.count == 0 then
							e = s
						end
						if cursor_line >= s and cursor_line <= e then
							hunk = h
							break
						end
					end
					if not hunk then
						hunk = hunks[1]
					end
					local lines = hunk.lines
					local width = math.max(40, math.floor(vim.o.columns * 0.55))
					local height = math.min(#lines, math.floor(vim.o.lines * 0.4))
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.bo[buf].filetype = "diff"
					vim.bo[buf].modifiable = false
					local win = vim.api.nvim_open_win(buf, true, {
						relative = "cursor",
						row = 1,
						col = 0,
						width = width,
						height = height,
						style = "minimal",
						border = "rounded",
						title = " Hunk Diff ",
						title_pos = "center",
					})
					vim.wo[win].wrap = false
					for _, key in ipairs({ "q", "<Esc>" }) do
						vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf, silent = true })
					end
				end, { desc = "Preview Hunk Float" })
				map("n", "<leader>ghi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

				map("n", "<leader>ghb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame Line" })

				map("n", "<leader>ghd", gitsigns.diffthis, { desc = "Diff This" })

				map("n", "<leader>ghD", function()
					gitsigns.diffthis("~")
				end, { desc = "Diff This ~" })

				local function open_hunks_in_telescope(all)
					local nr = all and "all" or 0
					gitsigns.setqflist(nr, { open = false })
					vim.schedule(function()
						require("telescope.builtin").quickfix()
					end)
				end

				map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff This" })
				map("n", "<leader>ghQ", function()
					open_hunks_in_telescope(true)
				end, { desc = "Hunks (all buffers)" })
				map("n", "<leader>ghq", function()
					open_hunks_in_telescope(false)
				end, { desc = "Hunks (buffer)" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Hunk" })
			end,
		})
	end,
}
