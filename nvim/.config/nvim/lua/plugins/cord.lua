return {
	"vyfor/cord.nvim",
	opts = {
		editor = {
			client = "neovim",
			tooltip = "The Superior Text Editor",
		},
		display = {
			theme = "default",
			flavor = "dark",
			swap_icons = true,
		},
		text = {
			workspace = function()
				return nil
			end,
			editing = function(opts)
				return "Editing a " .. (opts.tooltip ~= "" and opts.tooltip or opts.filetype) .. " file"
			end,
			viewing = function(opts)
				return "Viewing a " .. (opts.tooltip ~= "" and opts.tooltip or opts.filetype) .. " file"
			end,
		},
		timestamp = {
			enabled = true,
		},
		idle = {
			enabled = false,
		},
	},
}
