-- 1. Enable the undo file feature globally
vim.opt.undofile = true

-- 2. Create a clean-up function when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("CleanUndoFiles", { clear = true }),
  callback = function()
    -- Get the directory where Neovim stores its undo files
    local undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo/")

    -- Delete all files inside the undo directory on exit
    if vim.fn.isdirectory(undodir) == 1 then
      pcall(function()
        vim.fn.delete(undodir, "rf")
      end)
    end
  end,
})

-- 3. Live background file watcher for Claude / external edits
vim.o.autoread = true

local watch_group = vim.api.nvim_create_augroup("ClaudeBackgroundWatcher", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = watch_group,
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local path = vim.api.nvim_buf_get_name(buf)

    -- Skip special non-file buffers (like terminal, neo-tree, dashboard, etc.)
    if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "" or path == "" then
      return
    end

    -- Create an OS-level file system watcher for this specific file
    local watcher = vim.uv.new_fs_event()
    if watcher then
      watcher:start(
        path,
        {},
        vim.schedule_wrap(function(err, filename, events)
          if err then
            return
          end

          -- Refresh only if the buffer is valid and you don't have unsaved active edits
          if vim.api.nvim_buf_is_valid(buf) and not vim.api.nvim_get_option_value("modified", { buf = buf }) then
            -- Force Neovim to instantly pull the fresh changes from disk
            vim.cmd("checktime")
          end
        end)
      )
    end
  end,
})

-- 4. Enable automatic lsp reload when new python packages/modules/classes are loaded, cuz lsp legit dies
local function restart_python_lsp()
  vim.defer_fn(function()
    -- Find basedpyright or pyright client in active clients
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.name == "basedpyright" or client.name == "pyright" then
        -- LspRestart by name is cleaner than stopping/starting manually
        vim.cmd("LspRestart " .. client.name)
        vim.notify("basedpyright restarted (new module detected)", vim.log.levels.INFO, { title = "LSP" })
        break
      end
    end
  end, 500) -- small delay so the file is fully written before restart
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("PyrightReindex", { clear = true }),
  pattern = { "*/__init__.py", "*/**.py" },
  callback = function(args)
    local fname = vim.fn.fnamemodify(args.file, ":t")
    -- Only trigger on brand-new __init__.py (package creation)
    -- or new .py files that didn't exist before this session
    if fname == "__init__.py" then
      restart_python_lsp()
    end
  end,
})
