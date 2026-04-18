return {
  {
    "Saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default =
        vim.list_extend(opts.sources.default or {}, { "obsidian", "obsidian_new", "obsidian_tags" })
      opts.sources.providers = vim.tbl_extend("force", opts.sources.providers or {}, {
        obsidian = { name = "obsidian", module = "blink.compat.source" },
        obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
        obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
      })
      return opts
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    -- Also load when entering vault files
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/obsidian/main/**.md",
    },
    cmd = {
      "ObsidianNew",
      "ObsidianOpen",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianBacklinks",
      "ObsidianLinks",
      "ObsidianTags",
      "ObsidianRename",
      "ObsidianPasteImg",
      "ObsidianFollowLink",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianToggleCheckbox",
      "ObsidianTOC",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "Saghen/blink.compat",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/obsidian/main/",
        },
      },

      daily_notes = {
        folder = ".",
        date_format = "%Y-%m-%d",
      },

      notes_subdir = "inbox",

      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,

      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      ui = {
        enable = true,
      },

      attachments = {
        img_folder = "inbox/assets",
      },

      -- Force nvim-cmp source registration so blink.compat can pick them up
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
    },

    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's daily note" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in note" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search by tag" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
      { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    },
  },
}
