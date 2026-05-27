return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = { "accept", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "rounded",
        max_width = 80,
        wrap = true,
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        max_width = 80,
        wrap = true,
      },
    },
  },
}
