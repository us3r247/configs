-- To always should hidden and ignored files by default
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- This applies globally to all pickers (files, grep, smart, explorer, etc.)
      hidden = true,
      ignored = true,
    },
  },
}
