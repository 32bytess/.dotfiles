vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.timeoutlen = 200
vim.o.ttimeoutlen = 10

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.g.clipboard = {
	name = "wl-clipboard",
	copy = {
		["+"] = "wl-copy",
		["*"] = "wl-copy --primary",
	},
	paste = {
		["+"] = function()
			return vim.fn.systemlist("wl-paste 2>/dev/null")
		end,
		["*"] = function()
			return vim.fn.systemlist("wl-paste --primary 2>/dev/null")
		end,
	},
	cache_enabled = false,
}
vim.o.clipboard = "unnamedplus"
vim.g.lazyvim_check_order = false
