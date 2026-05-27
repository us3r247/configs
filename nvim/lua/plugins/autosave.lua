return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged", "TextChangedI" },
    },
    debounce_delay = 1000,
    condition = function(buf)
      -- FIXED: Uses the non-deprecated API to query the buffer type safely
      if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "" then
        return false
      end
      return true
    end,
  },
}
