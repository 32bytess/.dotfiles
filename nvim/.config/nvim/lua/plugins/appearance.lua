local function theme_colors()
	local themes = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/themes/"
	local nf = io.open(themes .. "current.nvim", "r")
	if not nf then return nil, nil end
	local name = nf:read("*l")
	nf:close()
	if not name then return nil, nil end
	local tf = io.open(themes .. name, "r")
	if not tf then return nil, nil end
	local content = tf:read("*a")
	tf:close()
	return content:match('ACCENT="(#%x+)"'), content:match('TEXT="(#%x+)"')
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.schedule(function()
			local path = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/themes/current.nvim"
			local f = io.open(path, "r")
			local name = f and f:read("*l") or "rose-pine"
			if f then f:close() end
			pcall(vim.cmd.colorscheme, name)
		end)
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local accent, text = theme_colors()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "FloatTitle", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = accent, bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent, bold = true })
		vim.api.nvim_set_hl(0, "LineNr", { fg = text })
		vim.api.nvim_set_hl(0, "YankHighlight", accent and { bg = accent, fg = "#000000", bold = true } or { link = "Visual" })
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		local path = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/themes/current.nvim"
		local f = io.open(path, "r")
		if not f then return end
		local name = f:read("*l")
		f:close()
		if name and name ~= vim.g.colors_name then
			pcall(vim.cmd.colorscheme, name)
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 150 })
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
