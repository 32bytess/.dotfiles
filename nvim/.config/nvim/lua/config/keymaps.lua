local oil = require("plugins.oil")._funcs
local claude = require("plugins.claude-code")._funcs

-- telescope
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find File" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })

-- oil
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent dir (Oil)" })
vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "Toggle Oil float" })

-- claude-code
vim.keymap.set("n", "<leader>og", claude.toggle_float, { desc = "Toggle Claude Code float" })
vim.keymap.set("v", "<leader>oa", claude.send_selection, { desc = "Add Selection to Claude" })

-- obsidian
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian app" })
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Find note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Today's daily note" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "Links in note" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Search by tag" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste image" })

-- close float windows with q
vim.keymap.set("n", "q", function()
	local win = vim.api.nvim_get_current_win()
	if vim.api.nvim_win_get_config(win).relative ~= "" then
		vim.api.nvim_win_close(win, false)
	else
		vim.fn.feedkeys("q", "n")
	end
end, { desc = "Close float / q" })

