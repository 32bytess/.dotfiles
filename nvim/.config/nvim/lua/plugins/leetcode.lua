return {
  "albertoodev/leetcode.nvim",
  dir = "~/projects/lua/leetcode.nvim",
  cond = vim.fn.isdirectory(vim.fn.expand("~/projects/lua/leetcode.nvim")) == 1,
  build = ":TSUpdate",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    arg = "leetcode.nvim",
    lang = "dart",
    directory = vim.fn.expand("$HOME") .. "/projects/leetcode",
    description = {
      position = "right",
    },
  },
}
