-- lua/plugins/lint.lua (wherever you configure nvim-lint)
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      ruff = {
        args = {
          "--select",
          "E,F,I,UP",
          "--ignore",
          "F401", -- pyright handles unused imports better
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
          "-",
        },
      },
    },
  },
}
