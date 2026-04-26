local M = {}

function M.setup()
	-- Construct the absolute path to your wallust-generated colors
	local colors_path = vim.fn.stdpath("config") .. "/lua/theme/colors.lua"

	-- dofile() bypasses the Lua cache and reads the file directly from disk
	-- It will return the table defined in your wallust/templates/nvim.lua
	local ok, c = pcall(dofile, colors_path)
	if not ok then
		vim.notify("Wallust colors not found in lua/theme/colors.lua", vim.log.levels.WARN)
		return
	end

	local hl = vim.api.nvim_set_hl

	local function blend(hex1, hex2, factor)
		local function parse(h)
			h = h:sub(2)
			return tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
		end
		local r1, g1, b1 = parse(hex1)
		local r2, g2, b2 = parse(hex2)
		return string.format(
			"#%02x%02x%02x",
			math.floor(r1 * factor + r2 * (1 - factor) + 0.5),
			math.floor(g1 * factor + g2 * (1 - factor) + 0.5),
			math.floor(b1 * factor + b2 * (1 - factor) + 0.5)
		)
	end

	-- Base UI
	hl(0, "Normal", { fg = c.foreground, bg = "NONE" })
	hl(0, "NormalNC", { bg = "NONE" })
	hl(0, "NormalFloat", { fg = c.foreground, bg = "NONE" })
	hl(0, "FloatBorder", { fg = c.color4, bg = "NONE" })

	hl(0, "FloatTitle", { fg = c.color4, bg = "NONE", bold = true })

	-- Telescope
	hl(0, "TelescopeNormal", { fg = c.foreground, bg = "NONE" })
	hl(0, "TelescopePromptPrefix", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePromptBorder", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopeResultsBorder", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePreviewBorder", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePromptTitle", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePromptCounter", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePreviewTitle", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopeResultsTitle", { fg = c.color4, bg = "NONE" })
	hl(0, "TelescopePromptPrefix", { fg = c.color4, bg = "NONE" })

	-- Cursor & selection
	hl(0, "CursorLine", { bg = blend(c.foreground, c.background, 0.12) })
	hl(0, "CursorLineNr", { fg = c.color4, bg = "NONE", bold = true })
	hl(0, "Visual", { bg = blend(c.color4, c.background, 0.35), bold = true })
	hl(0, "VisualNOS", { bg = blend(c.color4, c.background, 0.25) })

	-- Line numbers & signs
	hl(0, "LineNr", { fg = c.color8, bg = "NONE" })
	hl(0, "SignColumn", { bg = "NONE" })
	hl(0, "FoldColumn", { fg = c.color8, bg = "NONE" })
	hl(0, "Folded", { fg = c.color8, bg = c.color0, italic = true })

	-- Search
	hl(0, "Search", { fg = c.background, bg = c.color3 })
	hl(0, "IncSearch", { fg = c.background, bg = c.color4 })
	hl(0, "CurSearch", { fg = c.background, bg = c.color4, bold = true })
	hl(0, "Substitute", { fg = c.background, bg = c.color1 })

	-- Status & tab line
	hl(0, "StatusLine", { fg = c.foreground, bg = c.color0 })
	hl(0, "StatusLineNC", { fg = c.color8, bg = c.color0 })
	hl(0, "TabLine", { fg = c.color8, bg = c.color0 })
	hl(0, "TabLineSel", { fg = c.foreground, bg = "NONE", bold = true })
	hl(0, "TabLineFill", { bg = c.color0 })

	-- Window separators
	hl(0, "WinSeparator", { fg = c.color0 })

	-- Popup menu
	hl(0, "Pmenu", { fg = c.foreground, bg = "NONE" })
	hl(0, "PmenuSel", { fg = c.background, bg = c.color4, bold = true })
	hl(0, "PmenuSbar", { bg = "NONE" })
	hl(0, "PmenuThumb", { bg = c.color8 })

	-- Misc UI
	hl(0, "MatchParen", { fg = c.color4, bold = true, underline = true })
	hl(0, "EndOfBuffer", { fg = c.color0 })
	hl(0, "NonText", { fg = c.color0 })
	hl(0, "SpecialKey", { fg = c.color8 })
	hl(0, "Whitespace", { fg = c.color0 })
	hl(0, "Title", { fg = c.color4, bold = true })
	hl(0, "Question", { fg = c.color2 })
	hl(0, "MoreMsg", { fg = c.color2 })
	hl(0, "ModeMsg", { fg = c.foreground, bold = true })
	hl(0, "ErrorMsg", { fg = c.color1, bold = true })
	hl(0, "WarningMsg", { fg = c.color3 })

	-- Syntax
	hl(0, "Comment", { fg = c.color8, italic = true })
	hl(0, "Constant", { fg = c.color3 })
	hl(0, "String", { fg = c.color2 })
	hl(0, "Character", { fg = c.color2 })
	hl(0, "Number", { fg = c.color3 })
	hl(0, "Boolean", { fg = c.color3 })
	hl(0, "Float", { fg = c.color3 })
	hl(0, "Identifier", { fg = c.foreground })
	hl(0, "Function", { fg = c.color4, bold = true })
	hl(0, "Statement", { fg = c.color5, italic = true })
	hl(0, "Keyword", { fg = c.color5, italic = true })
	hl(0, "Conditional", { fg = c.color5, italic = true })
	hl(0, "Repeat", { fg = c.color5, italic = true })
	hl(0, "Operator", { fg = c.color5 })
	hl(0, "Exception", { fg = c.color1 })
	hl(0, "PreProc", { fg = c.color6 })
	hl(0, "Include", { fg = c.color6 })
	hl(0, "Define", { fg = c.color6 })
	hl(0, "Macro", { fg = c.color6 })
	hl(0, "Type", { fg = c.color6 })
	hl(0, "StorageClass", { fg = c.color5 })
	hl(0, "Structure", { fg = c.color6 })
	hl(0, "Typedef", { fg = c.color6 })
	hl(0, "Special", { fg = c.color4 })
	hl(0, "SpecialChar", { fg = c.color3 })
	hl(0, "Delimiter", { fg = c.color7 })
	hl(0, "Underlined", { underline = true })
	hl(0, "Error", { fg = c.color1, bold = true })
	hl(0, "Todo", { fg = c.background, bg = c.color3, bold = true })

	-- Treesitter
	hl(0, "@comment", { link = "Comment" })
	hl(0, "@keyword", { link = "Keyword" })
	hl(0, "@keyword.return", { fg = c.color1, italic = true })
	hl(0, "@function", { link = "Function" })
	hl(0, "@function.builtin", { fg = c.color4 })
	hl(0, "@function.call", { fg = c.color4 })
	hl(0, "@method", { fg = c.color4, bold = true })
	hl(0, "@method.call", { fg = c.color4 })
	hl(0, "@string", { link = "String" })
	hl(0, "@string.escape", { fg = c.color3 })
	hl(0, "@number", { link = "Number" })
	hl(0, "@float", { link = "Float" })
	hl(0, "@boolean", { link = "Boolean" })
	hl(0, "@type", { fg = c.color6 })
	hl(0, "@type.builtin", { fg = c.color6, italic = true })
	hl(0, "@variable", { fg = c.foreground })
	hl(0, "@variable.builtin", { fg = c.color5, italic = true })
	hl(0, "@parameter", { fg = c.foreground, italic = true })
	hl(0, "@field", { fg = c.color6 })
	hl(0, "@property", { fg = c.color6 })
	hl(0, "@namespace", { fg = c.color6 })
	hl(0, "@constant", { fg = c.color3 })
	hl(0, "@constant.builtin", { fg = c.color3, italic = true })
	hl(0, "@constructor", { fg = c.color6, bold = true })
	hl(0, "@operator", { fg = c.color5 })
	hl(0, "@punctuation.bracket", { fg = c.color7 })
	hl(0, "@punctuation.delimiter", { fg = c.color7 })
	hl(0, "@punctuation.special", { fg = c.color5 })
	hl(0, "@tag", { fg = c.color1 })
	hl(0, "@tag.attribute", { fg = c.color3 })
	hl(0, "@tag.delimiter", { fg = c.color8 })
	hl(0, "@attribute", { fg = c.color3 })

	-- Diagnostics
	hl(0, "DiagnosticError", { fg = c.color1 })
	hl(0, "DiagnosticWarn", { fg = c.color3 })
	hl(0, "DiagnosticInfo", { fg = c.color6 })
	hl(0, "DiagnosticHint", { fg = c.color5 })
	hl(0, "DiagnosticOk", { fg = c.color2 })
	hl(0, "DiagnosticUnderlineError", { sp = c.color1, undercurl = true })
	hl(0, "DiagnosticUnderlineWarn", { sp = c.color3, undercurl = true })
	hl(0, "DiagnosticUnderlineInfo", { sp = c.color6, undercurl = true })
	hl(0, "DiagnosticUnderlineHint", { sp = c.color5, undercurl = true })
	hl(0, "DiagnosticVirtualTextError", { fg = c.color1, bg = "NONE", italic = true })
	hl(0, "DiagnosticVirtualTextWarn", { fg = c.color3, bg = "NONE", italic = true })
	hl(0, "DiagnosticVirtualTextInfo", { fg = c.color6, bg = "NONE", italic = true })
	hl(0, "DiagnosticVirtualTextHint", { fg = c.color5, bg = "NONE", italic = true })
	hl(0, "DiagnosticSignError", { fg = c.color1, bg = "NONE" })
	hl(0, "DiagnosticSignWarn", { fg = c.color3, bg = "NONE" })
	hl(0, "DiagnosticSignInfo", { fg = c.color6, bg = "NONE" })
	hl(0, "DiagnosticSignHint", { fg = c.color5, bg = "NONE" })

	-- LSP
	hl(0, "LspReferenceText", { bg = c.color0, underline = true })
	hl(0, "LspReferenceRead", { bg = c.color0, underline = true })
	hl(0, "LspReferenceWrite", { bg = c.color0, bold = true, underline = true })
	hl(0, "LspInlayHint", { fg = c.color8, bg = "NONE", italic = true })

	-- Git signs
	hl(0, "GitSignsAdd", { fg = c.color2, bg = "NONE" })
	hl(0, "GitSignsChange", { fg = c.color3, bg = "NONE" })
	hl(0, "GitSignsDelete", { fg = c.color1, bg = "NONE" })
	hl(0, "GitSignsAddNr", { fg = c.color2 })
	hl(0, "GitSignsChangeNr", { fg = c.color3 })
	hl(0, "GitSignsDeleteNr", { fg = c.color1 })

	-- Diff
	hl(0, "DiffAdd", { fg = c.color2, bg = "NONE" })
	hl(0, "DiffChange", { fg = c.color3, bg = "NONE" })
	hl(0, "DiffDelete", { fg = c.color1, bg = "NONE" })
	hl(0, "DiffText", { fg = c.color4, bg = "NONE", bold = true })

	-- Lualine mode colors
	hl(0, "lualine_a_normal", { fg = c.background, bg = c.color4, bold = true })
	hl(0, "lualine_a_insert", { fg = c.background, bg = c.color2, bold = true })
	hl(0, "lualine_a_visual", { fg = c.background, bg = c.color3, bold = true })
	hl(0, "lualine_a_replace", { fg = c.background, bg = c.color1, bold = true })
	hl(0, "lualine_a_command", { fg = c.background, bg = c.color5, bold = true })
	hl(0, "lualine_a_inactive", { fg = c.color8, bg = c.color0 })

	-- Terminal colors
	for i = 0, 15 do
		vim.g["terminal_color_" .. i] = c["color" .. i]
	end
	vim.g.terminal_color_background = c.background
	vim.g.terminal_color_foreground = c.foreground
end

return M
