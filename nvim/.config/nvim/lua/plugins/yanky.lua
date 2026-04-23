return {
	"gbprod/yanky.nvim",
	opts = {
		ring = { history_length = 100 },
		highlight = { on_put = true, on_yank = true, timer = 150 },
	},
	config = function(_, opts)
		require("yanky").setup(opts)
		require("telescope").load_extension("yank_history")
	end,
}
