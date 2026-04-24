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
			return vim.fn.systemlist("wl-paste --no-newline 2>/dev/null")
		end,
		["*"] = function()
			return vim.fn.systemlist("wl-paste --no-newline --primary 2>/dev/null")
		end,
	},
	cache_enabled = false,
}
vim.o.clipboard = "unnamedplus"
vim.g.lazyvim_check_order = false
