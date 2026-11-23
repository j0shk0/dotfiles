-- Providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = "/usr/bin/python3" -- needs python3-pynvim

-- Plugins (lazy.nvim) {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins load eagerly; the setup() calls below stay exactly as before
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "nvim-tree/nvim-web-devicons",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  { "mason-org/mason.nvim", opts = {} },
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-buffer",
  { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
  "sphamba/smear-cursor.nvim",
  "nvim-tree/nvim-tree.lua",
  "windwp/nvim-autopairs",
  "nvim-lualine/lualine.nvim",
  "ray-x/lsp_signature.nvim",
  "stevearc/conform.nvim",
  "neovim/nvim-lspconfig", -- default configs for vim.lsp.enable()
}, { install = { colorscheme = { "catppuccin" } } })
-- }}}

-- Set up options {{{
do
  local options = {
    background = "light",
    cursorline = true,
    expandtab = true,
    number = true,
    shiftwidth = 2,
    showtabline = 2,
    softtabstop = 2,
    termguicolors = true,
  }
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
end
-- }}}

require("catppuccin").setup({ flavour = "latte" })
vim.cmd([[colorscheme catppuccin]])
require("nvim-web-devicons").setup({})

-- Treesitter {{{
local ts = require("nvim-treesitter")
ts.setup({})
ts.install({ "bash", "c", "cpp", "java", "json", "lua", "markdown",
  "markdown_inline", "python", "yaml" }) -- async; needs tree-sitter-cli + gcc

require("smear_cursor").setup({})
require("nvim-tree").setup({})
require("nvim-autopairs").setup({})
require("lualine").setup({ tabline = { lualine_a = { { "tabs", max_length = vim.o.columns, mode = 1 } } } })
require("lsp_signature").setup({})

require("conform").setup({
  formatters_by_ft = {
    ["*"] = { "trim_whitespace" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    elixir = { "mix" },
    java = { "google-java-format" },
    javascript = { "prettierd" },
    json = { "prettierd" },
    markdown = { "prettierd" },
    nix = { "nixfmt" },
    python = { "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    typescript = { "prettierd" },
    yaml = { "prettierd" },
  },
})

-- Keybinds {{{
vim.keymap.set({ "n", "v" }, "<C-M-l>", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file / selection" })
vim.keymap.set("n", "<M-1>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
-- }}}

vim.filetype.add({ extension = { tex = "tex" } })

-- LSP {{{
vim.lsp.config("clangd", { cmd = { "clangd", "--background-index" } })
for _, server in ipairs({ "clangd", "elixirls", "jdtls", "lua_ls", "nil_ls",
  "pyright", "rust_analyzer", "ts_ls" }) do
  vim.lsp.enable(server)
end
-- }}}
