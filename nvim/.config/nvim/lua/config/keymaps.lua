-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
--  Split
map("n", "<leader>v", "<cmd>split<cr>", { desc = "Split Below" })
map("n", "<leader>h", "<cmd>vsplit<cr>", { desc = "Split Right" })
-- Save
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>fS", "<cmd>wa<cr>", { desc = "Save All Files" })
-- Switch buffers
map("n", "<leader><tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Move in insert mode
map("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })
map("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })

map("i", "<A-a>", "<Esc>A", { desc = "Append at end of line" })

map("i", "<A-o>", "<Esc>o", { desc = "New line below" })

-- Adb wireless pairign via qr code
map("n", "<leader>ap", function()
  Snacks.terminal({ "adb-wifi" }, {
    start_insert = false,
    win = {
      style = "float",
      width = 0.50,
      height = 0.50,
    },
  })
end, { desc = "ADB Wireless Pair (QR)" })
