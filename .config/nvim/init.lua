-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ','
 
-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
vim.o.number = true -- Show line number on the side
vim.o.relativenumber = true
-- vim.o.tabstop = 4
-- vim.o.shiftwidth = 4
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
vim.o.guicursor = "" -- Keep terminal emulator defined GUI cursor style
vim.o.autoread= true -- Set to auto read when a file is changed from the outside
vim.o.magic = true --For regular expressions turn magic on
vim.o.backspace=2 -- Make backspace behave in a sane manner
vim.o.backspace=[[indent,eol,start]]
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '| ', trail = '·' }
		vim.o.mouse = "a"
vim.o.spelllang = "en_us"
vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
vim.api.nvim_create_autocmd('Filetype', { pattern = 'json', command = 'set formatprg=jq' })

 
-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('v','//',"\"fy/\\V<C-R>f<CR>",{})
vim.api.nvim_set_keymap('n','<leader><leader>','<c-^>',{})
vim.api.nvim_set_keymap('n','<leader><space>',':noh<cr>',{})
--vim.api.nvim_set_keymap('n','<leader>nt',':NERDTreeToggle<cr>',{})
-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
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
	-- main color scheme
	{
		"tanvirtin/monokai.nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			require('monokai')
			vim.g.monokai_term_italic = 1
			vim.g.monokai_gui_italic = 1

		end
	},
	-- nice bar at the bottom
	{
		'itchyny/lightline.vim',
		lazy = false, -- also load at start since it's UI
		config = function()
			-- no need to also show mode in cmd line when we have bar
			vim.o.showmode = false
			vim.g.lightline = {
				active = {
					left = {
						{ 'mode', 'paste' },
						{ 'readonly', 'filename', 'modified' }
					},
					right = {
						{ 'lineinfo' },
						{ 'percent' },
						{ 'fileencoding', 'filetype' }
					},
				},
				component_function = {
					filename = 'LightlineFilename'
				},
			}
			function LightlineFilenameInLua(opts)
				if vim.fn.expand('%:t') == '' then
					return '[No Name]'
				else
					return vim.fn.getreg('%')
				end
			end
			-- https://github.com/itchyny/lightline.vim/issues/657
			vim.api.nvim_exec(
			[[
			function! g:LightlineFilename()
			return v:lua.LightlineFilenameInLua()
			endfunction
			]],
			true
			)
		end
	},
	-- better %
	{
		'andymass/vim-matchup',
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end
	},
	-- auto-cd to root of git project
	-- 'airblade/vim-rooter'
	{
		'notjedi/nvim-rooter.lua',
		config = function()
			require('nvim-rooter').setup()
		end
	},
	-- plugins/telescope.lua:
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			--Find files using Telescope command-line sugar.
			vim.api.nvim_set_keymap('n','<leader>ff','<cmd>Telescope find_files hidden=true<cr>',{})
			vim.api.nvim_set_keymap('n','<leader>fg','<cmd>Telescope live_grep additional_args=--hidden<cr>',{})
			vim.api.nvim_set_keymap('n','<leader>fb','<cmd>Telescope buffers hidden=true<cr>',{})
			vim.api.nvim_set_keymap('n','<leader>fh','<cmd>Telescope help_tags hidden=true<cr>',{})
		end
	},
	-- NERDTree
	{
		'scrooloose/nerdtree',
		config = function()
			vim.api.nvim_set_keymap('n','<leader>nt','<cmd>NERDTreeToggle<cr>',{})
		end
	}
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

]]--
