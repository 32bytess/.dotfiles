-- override snacks to show hide .gitignore files and .files
return {
  "folke/snacks.nvim",
  opts = {
    notifier = { enabled = false },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
        },
      },
    },
  },
}
