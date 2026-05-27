return {
  -- LSP diagnostics: squiggles + signs, no inline virtual text
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- no inline error text
        underline = true, -- squiggles under text
        signs = true, -- icons in sign column
        update_in_insert = false, -- don't spam while typing
        severity_sort = true,
      },
    },
  },

  -- UI tweaks + hover diagnostics popup logic
  {
    "folke/snacks.nvim",
    opts = {
      words = { enabled = true },
    },
    init = function()
      -- Make all LSP floats rounded + wrapped by default
      if vim.lsp and vim.lsp.util and vim.lsp.util.open_floating_preview then
        local orig_open = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
          opts = opts or {}
          opts.border = opts.border or "rounded"
          opts.max_width = opts.max_width or 80
          opts.wrap = true
          return orig_open(contents, syntax, opts, ...)
        end
      end

      local diag_timer = nil
      local blink_ok, blink = pcall(require, "blink.cmp")

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = function()
          -- Cancel previous pending popup
          if diag_timer then
            diag_timer:stop()
            diag_timer = nil
          end

          -- If completion is visible, don't show diagnostics float
          if blink_ok and blink.is_visible() then
            return
          end

          local win = 0
          local buf = vim.api.nvim_get_current_buf()
          local pos = vim.api.nvim_win_get_cursor(win)
          local line = pos[1]

          -- Quick filter: any diagnostics on this line?
          local diagnostics = vim.diagnostic.get(buf, { lnum = line - 1 })
          if vim.tbl_isempty(diagnostics) then
            return
          end

          -- Start a 400ms timer; if cursor stays and is on a diagnostic, show popup
          diag_timer = vim.defer_fn(function()
            -- Buffer still valid and still current?
            if not vim.api.nvim_buf_is_valid(buf) or buf ~= vim.api.nvim_get_current_buf() then
              return
            end

            -- Completion might have appeared in the meantime
            if blink_ok and blink.is_visible() then
              return
            end

            -- scope = "cursor" ensures a popup only if cursor is on a diagnostic
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "CursorMoved", "CursorMovedI", "BufLeave" },
              source = "always",
              prefix = " ",
              scope = "cursor",
              border = "rounded",
            })
          end, 400)
        end,
      })
    end,
  },
}
