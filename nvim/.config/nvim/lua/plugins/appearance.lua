local themes_dir = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/themes/"

local function read_current_theme()
	local f = io.open(themes_dir .. "current.nvim", "r")
	if not f then
		return nil, nil, nil
	end
	local name = f:read("*l")
	f:close()
	if not name then
		return nil, nil, nil
	end
	local tf = io.open(themes_dir .. name, "r")
	if not tf then
		return name, nil, nil
	end
	local content = tf:read("*a")
	tf:close()
	return name, content:match('ACCENT="(#%x+)"'), content:match('TEXT="(#%x+)"')
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.schedule(function()
			local name = read_current_theme()
			pcall(vim.cmd.colorscheme, name or "rose-pine")
		end)
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local _, accent, text = read_current_theme()
		local transparent = { bg = "none" }
		for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat" }) do
			vim.api.nvim_set_hl(0, group, transparent)
		end
		for _, group in ipairs({
			"TelescopeNormal",
			"TelescopePromptNormal",
			"TelescopeResultsNormal",
			"TelescopePreviewNormal",
		}) do
			vim.api.nvim_set_hl(0, group, transparent)
		end
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "FloatTitle", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent, bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = text })
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		local name = read_current_theme()
		if name and name ~= vim.g.colors_name then
			pcall(vim.cmd.colorscheme, name)
		end
	end,
})

return {
	{
		"nvim-tree/nvim-web-devicons",
		priority = 1000,
		dependencies = { "DaikyXendo/nvim-material-icon" },
		config = function()
			local ok, material_icons = pcall(require, "nvim-material-icon")
			if not ok then
				require("nvim-web-devicons").setup({ default = true })
				return
			end
			require("nvim-web-devicons").setup({
				override = material_icons.get_icons(),
				default = true,
			})
		end,
	},
	{
		"b0o/incline.nvim",
		event = "VeryLazy",
		config = function()
			local devicons = require("nvim-web-devicons")
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					return {
						ft_icon and { " ", ft_icon, " ", guibg = "none", guifg = ft_color } or "",
						{ " " .. filename .. "", guibg = "none" },
						{ modified and " ● " or " ", guibg = "none", guifg = "#d19a66" },
					}
				end,
			})
		end,
	},

	-- themes

	{ "Mofiqul/dracula.nvim", lazy = true, opts = { transparent_bg = true } },

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		opts = {
			disable_background = true,
			styles = {
				background = "transparent",
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			float = { transparent = true },
		},
	},

	{ "folke/tokyonight.nvim", lazy = true, opts = { transparent = true } },

	{ "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = true } },

	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		opts = { contrast = "hard", transparent_mode = true },
	},

	{
		"shaunsingh/nord.nvim",
		lazy = true,
		init = function()
			vim.g.nord_disable_background = true
		end,
	},

	{
		"sainnhe/everforest",
		lazy = true,
		init = function()
			vim.g.everforest_background = "medium"
			vim.g.everforest_transparent_background = 1
		end,
	},

	{ "navarasu/onedark.nvim", lazy = true, opts = { transparent = true } },

	{
		"sainnhe/gruvbox-material",
		lazy = true,
		init = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_transparent_background = 1
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		opts = { options = { transparent = true } },
	},

	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = true,
		init = function()
			vim.g.moonflyTransparent = true
		end,
	},

	-- colors
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			render = "virtual",
			virtual_symbol_position = "inline",
			virtual_symbol_suffix = " ",
			custom_colors = {
				{ label = "%-%-theme%-primary", color = "#0f1219" },
				{ label = "%-%-theme%-secondary", color = "#00ff00" },
			},
		},
	},
}
