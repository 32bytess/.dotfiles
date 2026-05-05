local gemini = require("custom.term_float").new("gemini")

return {
	{
		"gemini-cli",
		dir = vim.fn.stdpath("config"),
		config = function()
			vim.keymap.set("n", "<leader>tg", gemini.toggle, { desc = "Toggle Gemini CLI float" })
			vim.keymap.set("v", "<leader>ta", gemini.send_selection, { desc = "Add Selection to Gemini" })
		end,
	},
}
