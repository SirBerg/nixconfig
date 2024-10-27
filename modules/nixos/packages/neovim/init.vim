lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()
require('nvim-treesitter').setup {
  highlight = {
    enable = true,


    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require('mason-tool-installer').setup {

  -- a list of all tools you want to ensure are installed upon
  -- start
  ensure_installed = {

    -- you can pin a tool to a particular version
    { 'golangci-lint', version = 'v1.47.0' },

    -- you can turn off/on auto_update per tool
    { 'bash-language-server', auto_update = true },

    'lua-language-server',
    'vim-language-server',
    'gopls',
    'stylua',
    'shellcheck',
    'editorconfig-checker',
    'gofumpt',
    'golines',
    'gomodifytags',
    'gotests',
    'impl',
    'json-to-struct',
    'luacheck',
    'misspell',
    'revive',
    'shellcheck',
    'shfmt',
    'staticcheck',
    'vint',
    'clangd',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = 5, -- at least 5 hours between attempts to install/update

  -- By default all integrations are enabled. If you turn on an integration
  -- and you have the required module(s) installed this means you can use
  -- alternative names, supplied by the modules, for the thing that you want
  -- to install. If you turn off the integration (by setting it to false) you
  -- cannot use these alternative names. It also suppresses loading of those
  -- module(s) (assuming any are installed) which is sometimes wanted when
  -- doing lazy loading.
  integrations = {
    ['mason-lspconfig'] = true,
  },
}
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.cmd[[colorscheme tokyonight-night]]
vim.opt.relativenumber = true


-- LSP Configs
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>ad', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>sd', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Lsp keymaps
local on_attach = function(client, bufnr)
    local opts_buffer = { noremap = true, silent = true, buffer = bufnr }
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings: LSP
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts_buffer)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts_buffer)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts_buffer)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts_buffer)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts_buffer)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts_buffer)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts_buffer)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts_buffer)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts_buffer)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts_buffer)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts_buffer)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts_buffer)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts_buffer)
    vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts_buffer)
end

local lsp_flags = {
    debounce_text_changes = 150,
}

-- LSP Server setups
require('lspconfig')['clangd'].setup({
    -- LSP-default-keymaps
    on_attach = on_attach,
    flags = lsp_flags,
})
EOF

let g:rainbow_active=1
