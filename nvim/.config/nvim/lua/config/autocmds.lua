-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
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

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp", "*.svg", "*.pdf" },
  callback = function(ev)
    vim.fn.jobstart({ "xdg-open", ev.file }, { detach = true })
    vim.schedule(function()
      vim.api.nvim_buf_delete(ev.buf, { force = true })
    end)
  end,
})
