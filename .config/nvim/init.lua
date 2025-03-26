vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ','

-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
vim.o.number = true -- Show line number on the side
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
--vim.o.ai = true --Auto indent
--vim.o.si = true --Smart indent
--vim.o.incsearch = true -- Search as typing
vim.o.virtualedit = "onemore" --Allow the cursor to move just past the end of the line
vim.o.scrolloff = 10
vim.o.gdefault = true --The substitute flag g is on
vim.o.showbreak = "↪" -- See this char when wrapping text
vim.o.encoding = "utf-8" --The encoding displayed.
vim.o.fileencoding = "utf-8" --The encoding written to file.
vim.o.ignorecase = true -- Search insensitive
vim.o.smartcase = true -- but smart
-- vim.o.guicursor = "" -- Keep terminal emulator defined GUI cursor style
vim.o.autoread = true -- Set to auto read when a file is changed from the outside
vim.o.magic = true --For regular expressions turn magic on
-- vim.o.backspace=2 -- Make backspace behave in a sane manner
vim.o.backspace = [[indent,eol,start]]
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '| ', trail = '·' }
vim.o.mouse = "a"
vim.o.spelllang = "en_us"
vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
vim.api.nvim_create_autocmd('Filetype', { pattern = 'json', command = 'set formatprg=jq' })
-- Change the vim shell for syntastic (can't handle fish)
vim.o.shell = "bash"

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('v', '//', "\"fy/\\V<C-R>f<CR>", {})
vim.api.nvim_set_keymap('n', '<leader><leader>', '<c-^>', {})
vim.api.nvim_set_keymap('n', '<leader><space>', ':noh<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>p', '"_dP', {})

-- insert new line without going into insert mode
vim.api.nvim_set_keymap('n', '<leader>o', 'o<esc>', {})
vim.api.nvim_set_keymap('n', '<leader>O', 'O<esc>', {})

-- Remap
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", {})
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", {})
vim.api.nvim_set_keymap("n", "n", "nzzzv", {})
vim.api.nvim_set_keymap("n", "N", "Nzzzv", {})

-- greatest remap ever
vim.api.nvim_set_keymap("x", "<leader>p", [["_dP]], {})

-- next greatest remap ever : asbjornHaland
vim.api.nvim_set_keymap("n", "<leader>y", [["+y]], {})
vim.api.nvim_set_keymap("v", "<leader>y", [["+y]], {})
vim.api.nvim_set_keymap("n", "<leader>Y", [["+Y]], {})

-- better navigation through quicklist
vim.api.nvim_set_keymap("n", "<M-k>", "<cmd>cnext<CR>", {})
vim.api.nvim_set_keymap("n", "<M-j>", "<cmd>cprev<CR>", {})

-------------------------------------------------------------------------------
--
-- Others
--
-------------------------------------------------------------------------------
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local servers = {
-- 	"lua_ls",
-- 	"rust_analyzer"
-- }
--
-- for _, lsp in ipairs(servers) do
-- 	lspconfig[lsp].setup {
-- 		-- on_attach = my_custom_on_attach,
-- 		capabilities = capabilities,
-- 	}
-- end

-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		vim.lsp.inlay_hint.enable()

		-- Diagnostic keymaps
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
		vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
		-- FIXME add bqf for fzf and more on quicklist
		-- Use 'setqflist' instead of 'setloclist' to get diagnostic from all files and not only current
		vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open diagnostic [Q]uickfix list' })
		vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist,
			{ desc = 'Open diagnostic [Lo]ocal [Q]uickfix list' })

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		-- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		-- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		-- vim.keymap.set('n', '<leader>wl', function()
		-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end, opts)
		-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)

		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		vim.api.nvim_create_autocmd('BufWritePre', {
			callback = function()
				vim.lsp.buf.format {
					async = false,
				}
			end,
		})

		-- None of this semantics tokens business.
		-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
		client.server_capabilities.semanticTokensProvider = nil
	end

})
-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- then, setup!
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	checker = { enable = true },
})


--[[
Leftover plugins i didn't migrate yet:
- 'sheerun/vim-polyglot'
- 'Yggdroot/indentLine'
- 'airblade/vim-gitgutter'
- 'scrooloose/nerdtree'
- 'Xuyuanp/nerdtree-git-plugin'
- 'FabijanZulj/blame.nvim'
- 'elzr/vim-json'
- 'bronson/vim-trailing-whitespace'
- 'jiangmiao/auto-pairs'
- 'dhruvasagar/vim-table-mode'
- 'godlygeek/tabular'
- 'momota/cisco.vim'
- 'junegunn/vim-easy-align'
- 'nvim-lua/popup.nvim'
- 'nvim-tree/nvim-tree.lua'
- 'junegunn/fzf', { 'do': { -> fzf#install() } }
- 'junegunn/fzf.vim'

]] --
