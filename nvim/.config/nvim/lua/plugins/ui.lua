return {
  -- Disable the default icon
  { "mini-icons/mini.icons", enabled = false },
  -- nvim-material-icon
  {
    "nvim-tree/nvim-web-devicons",
    priority = 1000,
    dependencies = { "DaikyXendo/nvim-material-icon" },
    config = function()
      local ok, material_icons = pcall(require, "nvim-material-icon")
      if not ok then
        require("nvim-web-devicons").setup({ default = true })
        return
      end

      -- If we are here, the plugin is installed. Proceed as normal.
      require("nvim-web-devicons").setup({
        override = material_icons.get_icons(),
        default = true,
      })
    end,
  },
  -- Buffer floating name
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = "none", guifg = ft_color } or "",
            { " " .. filename .. "", guibg = "none" },
            { modified and " ● " or " ", guibg = "none", guifg = "#d19a66" },
          }
        end,
      })
    end,
  },
  -- Disable buffer bar
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- ── Colorschemes ─────────────────────────────────────────────────────────

  { "Mofiqul/dracula.nvim", lazy = true, opts = { transparent_bg = true } },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      disable_background = true,
      styles = {
        background = "transparent",
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },

  { "folke/tokyonight.nvim", lazy = true, opts = { transparent = true } },

  { "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = true } },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = { contrast = "hard", transparent_mode = true },
  },

  {
    "shaunsingh/nord.nvim",
    lazy = true,
    init = function()
      vim.g.nord_disable_background = true
    end,
  },

  {
    "sainnhe/everforest",
    lazy = true,
    init = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_transparent_background = 1
    end,
  },

  { "navarasu/onedark.nvim", lazy = true, opts = { transparent = true } },

  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_transparent_background = 1
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = { options = { transparent = true } },
  },

  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = true,
    init = function()
      vim.g.moonflyTransparent = true
    end,
  },

  -- ── LazyVim: colorscheme from central themes state ───────────────────────

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local path = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/themes/current.nvim"
        local f = io.open(path, "r")
        local name = f and f:read("*l") or "moonfly"
        if f then
          f:close()
        end
        vim.cmd.colorscheme(name)
      end,
    },
  },
}
