-- Appearance
vim.o.cursorline = true
vim.o.number = true
vim.o.showmatch = true

require('catppuccin').setup({
  flavour = 'latte',
})

vim.o.background = 'light'
vim.cmd.colorscheme('catppuccin')

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- LSP servers (same executable() guard as before)
local servers = {
  clangd = {
    cmd = { 'clangd', '--background-index' },
    filetypes = { 'c', 'cpp', 'objc' },
    root_markers = { 'compile_commands.json', '.clangd', '.git' },
  },
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
  },
  pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  },
  elixirls = {
    cmd = { 'elixir-ls' },
    filetypes = { 'elixir', 'eelixir' },
    root_markers = { 'mix.exs', '.git' },
  },
  jdtls = {
    cmd = { 'jdtls', '-data',
      vim.fn.expand('~/.cache/jdtls/') .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') },
    filetypes = { 'java' },
    root_markers = { 'pom.xml', 'build.gradle', '.git' },
  },
}

for name, cfg in pairs(servers) do
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.config[name] = cfg
    vim.lsp.enable(name)
  end
end

-- Autocompletion (replaces asyncomplete + asyncomplete-lsp)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
  end,
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Diagnostics: no inline text, toggle everything with <leader>d - <leader> is "\" by default in vim.
-- <C-w>d — floating window with the full diagnostic for the line under your cursor.
-- ]d / [d — jump to next/previous diagnostic.
-- :lua vim.diagnostic.setloclist() — every diagnostic in the file.
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

-- Format (replaces vim-clang-format; clangd reads your .clang-format)
-- As we see its can be triggered by <leader>f
vim.keymap.set({ 'n', 'x' }, '<leader>f', vim.lsp.buf.format)

-- VimTeX
vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0

-- NERDTree
vim.g.NERDTreeShowHidden = 1
vim.keymap.set('n', '<leader>n', '<cmd>NERDTreeFocus<CR>')
vim.keymap.set('n', '<C-n>', '<cmd>NERDTree<CR>')
vim.keymap.set('n', '<C-t>', '<cmd>NERDTreeToggle<CR>')
vim.keymap.set('n', '<C-f>', '<cmd>NERDTreeFind<CR>')

-- Statusline
require('lualine').setup({ options = { theme = 'catppuccin-latte' } })
require('nvim-autopairs').setup({})
