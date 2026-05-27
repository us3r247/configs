-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "standard",
            },
          },
          python = {
            pythonPath = (function()
              -- 1. respect an activated venv (someone sourced it before opening nvim)
              local venv_bin = os.getenv("VIRTUAL_ENV")
              if venv_bin then
                return venv_bin .. "/bin/python"
              end
              -- 2. uv default: .venv in project root
              local uv_venv = vim.fn.getcwd() .. "/.venv/bin/python"
              if vim.fn.executable(uv_venv) == 1 then
                return uv_venv
              end
              -- 3. fallback to whatever python3 is on PATH
              return vim.fn.exepath("python3") or vim.fn.exepath("python")
            end)(),
          },
        },
      },
    },
    diagnostics = {
      virtual_text = false,
      underline = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
    },
  },
}
