return {
  "folke/snacks.nvim",
  opts = {
    notifier = { enabled = false },
    terminal = { enabled = false },
    input = { enabled = true, win = { zindex = 300, relative = "cursor", row = -3, col = 0 } },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
          layout = { preset = "default" },
          jump = { close = true },
          actions = {
            explorer_rename = function(picker, item)
              item = item or picker:current()
              if not item then return end
              local from = vim.fn.fnamemodify(item.file, ":p")
              local root = vim.fn.getcwd(0)
              local rel = from:find(root, 1, true) == 1 and from:sub(#root + 2) or from
              Snacks.input({ prompt = "Rename: ", default = rel }, function(value)
                if not value or value == "" or value == rel then return end
                local to = root .. "/" .. value
                Snacks.rename.rename_file({
                  from = from,
                  to = to,
                  on_rename = function(new, _)
                    picker:find({ refresh = true, target = new })
                  end,
                })
              end)
            end,
          },
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
