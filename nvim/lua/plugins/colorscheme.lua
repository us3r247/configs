return {
  -- Existing theme: Nightfox
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },

  -- New theme 1: Flexoki
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
  },

  -- New theme 2: Moonfly
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load your default theme
  {
    "LazyVim/LazyVim",
    opts = {
      -- Change this string to "flexoki" or "moonfly" to switch defaults
      colorscheme = "flexoki",
    },
  },
}
