require("mason").setup()

-- Function to set up keybindings when LSP attaches
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true }
  
  -- Key mappings for LSP functionality
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
end

-- LSP capabilities for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python LSP (pyright)
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    python = {
      analysis = {
        -- Minimal analysis to reduce noise
        typeCheckingMode = "off",
        autoImportCompletions = true,
      }
    }
  }
}

-- C LSP (clangd)
vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy=false", -- Disable linting
    "--completion-style=detailed",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
}

-- Auto-attach LSP to buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "c", "cpp" },
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    
    if ft == "python" then
      vim.lsp.start({
        name = "pyright",
        cmd = vim.lsp.config.pyright.cmd,
        root_dir = vim.fs.root(bufnr, vim.lsp.config.pyright.root_markers),
        settings = vim.lsp.config.pyright.settings,
        capabilities = capabilities,
        on_attach = on_attach,
      })
    elseif ft == "c" or ft == "cpp" then
      vim.lsp.start({
        name = "clangd",
        cmd = vim.lsp.config.clangd.cmd,
        root_dir = vim.fs.root(bufnr, vim.lsp.config.clangd.root_markers),
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end
  end,
})
