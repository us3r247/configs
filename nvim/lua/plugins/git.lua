return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Turns on inline git blame globally
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- Places the blame at the end of the line
        delay = 400, -- Delay in milliseconds before blame text shows up
        ignore_whitespace = false,
      },
    },
  },
}
