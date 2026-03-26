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
            { " " .. filename .. " ", guibg = "none" },
            { modified and " ● " or " ", guibg = "none", guifg = "#d19a66" }, -- Dirty circle color
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
  -- colorScheme
  {
    "Mofiqul/dracula.nvim",
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      disable_background = true,

      styles = {
        background = "transparent",
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    priority = 1000,
  },
  --- cappuccino
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
