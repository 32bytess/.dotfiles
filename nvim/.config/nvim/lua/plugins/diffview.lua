return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff branch vs main" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File git history" },
  },
}
