local claude = require("custom.term_float").new("claude")

return {
	"coder/claudecode.nvim",
	config = function()
		vim.keymap.set("n", "<leader>og", claude.toggle, { desc = "Toggle Claude Code float" })
		vim.keymap.set("v", "<leader>oa", claude.send_selection, { desc = "Add Selection to Claude" })
	end,
}
