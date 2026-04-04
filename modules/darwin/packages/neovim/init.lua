-- Requires
local treesitter_configs = require("nvim-treesitter")
local nvim_lspconfig = require('lspconfig')
local mason = require('mason').setup()
local mason_lspconfig = require('mason-lspconfig').setup({
	automatic_enable = true
})
local mason_tool_installer = require('mason-tool-installer')
local cmp = require('cmp')
local which_key = require('which-key')
local telescope_builtin = require('telescope.builtin')
local illuminate = require('illuminate')
local autopairs = require('nvim-autopairs')
local indent_guide = require('ibl')
local bufferline = require('bufferline')
local obsidian = require('obsidian')
local snacks = require('snacks')
local render_markdown = require('render-markdown')

-- Verify that lsp is working
--require('vim.lsp.health').check()

--###############################
--
--Plugin Setups
--
--###############################

--Treesitter
treesitter_configs.setup({
	ensure_installed = "all",
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

--CMP
cmp.setup({
	sources = {
		{name = 'nvim_lsp'}
	},
	mapping = {
		['<cr>'] = cmp.mapping.confirm({select = false}),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-k>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
		['<C-j>'] = cmp.mapping.select_next_item({behavior = 'select'}),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({behavior = 'insert'})
			else
				cmp.complete()
			end
		end),
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({behavior = 'insert'})
			else
				cmp.complete()
			end
		end),
	}
})

--Mason
mason_tool_installer.setup {
	ensure_installed = {
		'golangci-lint',
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
		'misspell',
		'revive',
		'shellcheck',
		'shfmt',
		'staticcheck',
		'vint',
		'clangd',
		'ts_ls'
  	},
	auto_update = false,
	run_on_start = true,
	start_delay = 0,
	debounce_houers = 5,
	integrations = {
		['mason-lspconfig'] = true,
	}
}

-- Illuminate
illuminate.configure({
	providers = {
		'lsp',
		'treesitter',
		'regex'
	},
	delay = 100,
	under_cursor = true,
	large_file_cutoff = 10000,
	large_file_overrides = nil,
	min_count_to_highlight = 1,
	case_insensitive_regex = false,
	disable_keymaps = false,
})

-- Autopairs
autopairs.setup({
	disable_filetype = { "TelescopePrompt", "vim", "spectre_panel", "snacks_picker_input" }
})

-- Indent blankline Guide
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
indent_guide.setup({indent = {highlight = highlight}})

-- Bufferline
vim.opt.termguicolors = true
bufferline.setup()

-- Obsidian
obsidian.setup({
	legacy_commands = false,
	ui = {
		enable = true
	},
	workspaces = {
		{
			name = "Main",
			path = "~/Documents/Main"
		}
	},
	templates = {
		folder = "Templates"
	},
	attachments = {
		folder = "Assets",
	},
})
-- Obsidian requires vim.opts.conceallevel to be either 1 or 2 so setting it to 2 here
vim.opt.conceallevel = 2

-- Snacks.nvim (used for image rendering)
snacks.setup({
	image = {
		resolve = function(path, src)			    
			local api = require "obsidian.api"
			if api.path_is_note(path) then
				return api.resolve_attachment_path(src)
			end
		end,
	}
})



--###############################
--
--KEYBINDS
--
--###############################
-- Leader = Space
vim.g.mapleader = " "
-- Relative line numbers
vim.opt.relativenumber = true
-- Set unwrap 
vim.opt.wrap = false
-- Load netrw (leader + p + v)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Open Netrw"})
-- Colorscheme
vim.cmd[[colorscheme retrobox]]

-- LSP Configs
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts, {desc = "Open Floating LSP Diagnostic Window"})
vim.keymap.set('n', '<leader>ad', vim.diagnostic.goto_prev, opts, {desc = "Previous Diagnostic"})
vim.keymap.set('n', '<leader>sd', vim.diagnostic.goto_next, opts, {desc = "Next Diagnostic"})
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts, {desc = "Show LOC List"})

-- Telescope Configs
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Telescope live grep'})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Telescope buffers'})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {desc = 'Telescope help tags'})

-- Nerd tree config
vim.cmd("nnoremap <leader>pn :NERDTreeFocus<cr>", {desc = "Focus Nerd Tree"})
vim.cmd("nnoremap <leader>pf :NERDTreeFind<cr>", {desc = "Find in Nerd Tree"})
vim.cmd("nnoremap <leader>pt :NERDTreeToggle<cr>", {desc = "Toggle Nerd Tree"})

-- Terminal in vim 
vim.keymap.set(
    'n',
    '<leader>t',
    [[<cmd>vsplit | term<cr>A]],
    { desc = 'Open terminal in horizontal split' }
)
vim.keymap.set(
    't',
    'jk',
    '<C-\\><C-n>',
    { desc = 'Use jk to enter in terminal normal mode' }
)
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', {desc = "Escape from terminal mode"})

-- Splits
vim.keymap.set('n', '<leader>sv', '<C-W>v', {desc = "Split window vertically"})
vim.keymap.set('n', '<leader>sh', '<C-W>S', {desc = "Split window horizontally"})
vim.keymap.set('n', '<leader>ml', '<C-W>r', {desc = "Rotate Windows to the right"})
vim.keymap.set('n', '<leader>mh', '<C-W>R', {desc = "Rotate Windows to the left"})
vim.keymap.set('n', '<leader>wh', '<C-W>h', {desc = "Move Cursor to the left Window from currently focused"})
vim.keymap.set('n', '<leader>wl', '<C-W>l', {desc = "Move Cursor to the right Window from currently focused"})
vim.keymap.set('n', '<leader>wj', '<C-W>j', {desc = "Move Cursor down Window from currently focused"})
vim.keymap.set('n', '<leader>wk', '<C-W>k', {desc = "Move Cursor up Window from currently focused"})

-- Obsidian.nvim remaps
vim.cmd("nnoremap <leader>ol :Obsidian link<cr>", {desc = "Link an Obsidian File"})
vim.cmd("nnoremap <leader>op :Obsidian paste_img<cr>", {desc = "Paste an Image into an obsidian file"})
vim.cmd("nnoremap <leader>of :Obsidian search<cr>", {desc = "Find an Obsidian note"})
vim.cmd("nnoremap <leader>on :Obsidian new<cr>", {desc = "Create an Obsidian File"})


--############################
--
--Other
--
--############################

-- Red undercurl (wavy underline like IntelliJ) for errors
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
	undercurl = true,
	sp = "#db4b4b",
})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
	undercurl = true,
	sp = "#e0af68",
})

-- Diagnostic display config
vim.diagnostic.config({
	underline = true,          -- enables the underline/undercurl
	virtual_text = {
		source = "if_many",      -- show source name if multiple LSPs
		prefix = "●",
	},
	signs = {
	text = {
		[vim.diagnostic.severity.ERROR] = " ",
		[vim.diagnostic.severity.WARN]  = " ",
		[vim.diagnostic.severity.HINT]  = " ",
		[vim.diagnostic.severity.INFO]  = " ",
	},
	},
	update_in_insert = true,  -- don't show errors while typing
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- Show diagnostic float automatically when cursor rests on an error
vim.opt.updatetime = 250  -- faster hover (default is 4000ms)

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "always",
			scope = "cursor",
			close_events = {
				"BufLeave", "CursorMoved", "InsertEnter", "FocusLost",
			},
		})
	end,
})


-- Enable inlay hints globally on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
