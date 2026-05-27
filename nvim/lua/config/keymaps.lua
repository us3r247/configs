-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- 1. New unnamed buffer
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New Unnamed Buffer" })

-- 2. Toggle terminal with Ctrl + `
vim.keymap.set({ "n", "t" }, "<C-`>", function()
  Snacks.terminal.focus(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

-- 3. Word-wise navigation in Normal Mode
vim.keymap.set("n", "<C-Left>", "b", { desc = "Word Backward" })
vim.keymap.set("n", "<C-Right>", "w", { desc = "Word Forward" })
-- Unified Page Up / Page Down via Ctrl + Up / Ctrl + Down
vim.keymap.set("n", "<C-Up>", "<C-u>", { desc = "Page Up" })
vim.keymap.set("n", "<C-Down>", "<C-d>", { desc = "Page Down" })

-- 4. Buffer switching (Shift + Arrow Keys)
vim.keymap.set("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- 5. Window switching (Alt + Arrow Keys)
vim.keymap.set("n", "<A-Left>", "<C-w>h", { desc = "Go to Left Window" })
vim.keymap.set("n", "<A-Down>", "<C-w>j", { desc = "Go to Lower Window" })
vim.keymap.set("n", "<A-Up>", "<C-w>k", { desc = "Go to Upper Window" })
vim.keymap.set("n", "<A-Right>", "<C-w>l", { desc = "Go to Right Window" })

-- Fix WezTerm Alt+Shift+Arrow escape codes for Neovim Window Resizing
vim.keymap.set("n", "\x1b[1;4A", "<A-S-Up>", { remap = true })
vim.keymap.set("n", "\x1b[1;4B", "<A-S-Down>", { remap = true })
vim.keymap.set("n", "\x1b[1;4C", "<A-S-Right>", { remap = true })
vim.keymap.set("n", "\x1b[1;4D", "<A-S-Left>", { remap = true })

-- 6. Window resizing (Alt + Shift + Arrows)
vim.keymap.set("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Resize Up" })
vim.keymap.set("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Resize Down" })
vim.keymap.set("n", "<A-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Resize Left" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize Right" })

-- 7. Ctrl Backspace for word delete in insert mode
vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true })

-- 8.Format and Save (Disabled autofmt cuz it messes with autosave)
-- Format the buffer using Conform, then write the file to save it
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  -- Try formatting with conform, then save
  require("conform").format({ lsp_format = "fallback" }, function(err)
    if not err then
      vim.cmd("write")
    else
      vim.notify("Formatting failed, file not saved", vim.log.levels.ERROR)
    end
  end)
end, { desc = "Format and Save File" })

-- 9. Go to definition via Ctrl+ Click
vim.keymap.set({ "n", "i" }, "<C-LeftMouse>", function()
  local mouse_pos = vim.fn.getmousepos()

  if mouse_pos.winid == 0 or vim.api.nvim_win_get_config(mouse_pos.winid).relative ~= "" then
    return
  end

  vim.api.nvim_set_current_win(mouse_pos.winid)
  vim.api.nvim_win_set_cursor(mouse_pos.winid, { mouse_pos.line, mouse_pos.column - 1 })

  Snacks.picker.lsp_references()
end, { desc = "Ctrl+Click: LSP References" })

vim.keymap.set({ "n", "i" }, "<C-Space>", function()
  Snacks.picker.lsp_references()
end, { desc = "LSP references (Snacks)" })

-- 10. Git stuff
vim.keymap.set("n", "<leader>ge", function()
  Snacks.picker.explorer({ git_status = true })
end, { desc = "Git Sidebar Explorer" })

-- 11.Undo stuff

-- Disable terminal suspension in Normal mode
vim.keymap.set("n", "<C-z>", "<Nop>", { noremap = true, desc = "Disable suspend" })

-- ==========================================
-- NORMAL MODE (Uniform Chronological Control)
-- ==========================================
-- u or Ctrl+z steps back exactly 1 autosave file checkpoint
vim.keymap.set("n", "u", "<cmd>earlier 1f<cr>", { desc = "Linear Chronological Undo" })
vim.keymap.set("n", "<C-z>", "<cmd>earlier 1f<cr>", { desc = "Linear Chronological Undo" })

-- FIXED: Uses native redo to prevent freezing when jumping forward from the oldest change
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Native Redo" })

-- ==========================================
-- INSERT MODE (Uniform Chronological Control)
-- ==========================================
-- Ctrl+z undos your last typed block while staying in Insert mode
vim.keymap.set("i", "<C-z>", "<C-o>:earlier 1f<cr>", { noremap = true, desc = "Linear Undo in Insert mode" })

-- FIXED: Uses the formal chronological forward step via command line
vim.keymap.set("i", "<C-y>", "<C-o>:later 1<cr>", { noremap = true, desc = "Linear Redo in Insert mode" })
