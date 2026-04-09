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
          layout = { preset = "default" },
          jump = { close = true },
        },
      },
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.picker.explorer()
      end,
      desc = "Explorer",
    },
  },
}
