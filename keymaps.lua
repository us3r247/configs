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
