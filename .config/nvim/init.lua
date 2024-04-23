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
vim.o.tabstop = 4
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
vim.o.autoread= true -- Set to auto read when a file is changed from the outside
vim.o.magic = true --For regular expressions turn magic on
-- vim.o.backspace=2 -- Make backspace behave in a sane manner
vim.o.backspace=[[indent,eol,start]]
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '| ', trail = '·' }
		vim.o.mouse = "a"
vim.o.spelllang = "en_us"
vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
vim.api.nvim_create_autocmd('Filetype', { pattern = 'json', command = 'set formatprg=jq' })
-- Change the vim shell for syntastic (can't handle fish)
vim.o.shell="bash"

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('v','//',"\"fy/\\V<C-R>f<CR>",{})
vim.api.nvim_set_keymap('n','<leader><leader>','<c-^>',{})
vim.api.nvim_set_keymap('n','<leader><space>',':noh<cr>',{})
vim.api.nvim_set_keymap('n','<leader>p','"_dP',{})
--vim.api.nvim_set_keymap('n','<leader>nt',':NERDTreeToggle<cr>',{})

-- insert new line without going into insert mode
vim.api.nvim_set_keymap('n','<leader>o','o<esc>',{})
vim.api.nvim_set_keymap('n','<leader>O','O<esc>',{})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

-- Use K to show documentation in preview window
function _G.show_more_docs()
	if vim.api.nvim_eval('coc#float#has_float') then
		vim.fn.CocActionAsync('coc#float#jump()')
		vim.api.nvim_set_keymap("<buffer>", "q", "<Cmd>close<CR>",{})
	end
end

vim.cmd(
[[
	function! ShowMoreDocumentation()
		if coc#float#has_float()
			call coc#float#jump()
			nnoremap <buffer> q <Cmd>close<CR>
		endif
	endfunction

]])

local opts = {silent = true, nowait = true, expr = true}
vim.api.nvim_set_keymap("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
vim.api.nvim_set_keymap("n", "M", ':call ShowMoreDocumentation()<CR>', {silent = true})

-- Remap
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz",{})
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz",{})
vim.api.nvim_set_keymap("n", "n", "nzzzv",{})
vim.api.nvim_set_keymap("n", "N", "Nzzzv",{})

-- greatest remap ever
vim.api.nvim_set_keymap("x", "<leader>p", [["_dP]],{})

-- next greatest remap ever : asbjornHaland
vim.api.nvim_set_keymap("n", "<leader>y", [["+y]],{})
vim.api.nvim_set_keymap("v", "<leader>y", [["+y]],{})
vim.api.nvim_set_keymap("n", "<leader>Y", [["+Y]],{})


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
			require('monokai').setup()
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
						{ 'cocstatus', 'readonly' },
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
			vim.api.nvim_set_keymap('n','<leader>b','<cmd>Telescope buffers hidden=true<cr>',{})
			vim.api.nvim_set_keymap('n','<leader>fh','<cmd>Telescope help_tags hidden=true<cr>',{})
		end
	},

	{
		'neoclide/coc.nvim', branch = 'release',
		config = function()
			-- GoTo code navigation.
			vim.api.nvim_set_keymap('n','gd','<Plug>(coc-definition)',{silent=true})
			vim.api.nvim_set_keymap('n','gy','<Plug>(coc-type-definition)',{silent=true})
			vim.api.nvim_set_keymap('n','gi','<Plug>(coc-implementation)',{silent=true})
			vim.api.nvim_set_keymap('n','gr','<Plug>(coc-references)',{silent=true})

			-- GoTo next error
			vim.api.nvim_set_keymap('n','<leader>j','<Plug>(coc-diagnostic-next-error)',{silent=true})
			-- GoTo previous error
			vim.api.nvim_set_keymap('n','<leader>k','<Plug>(coc-diagnostic-prev-error)',{silent=true})
			-- -- GoTo next diagnostic
			-- vim.api.nvim_set_keymap('n','<leader>j','<Plug>(coc-diagnostic-next)',{})
			-- -- GoTo previous diagnostic
			-- vim.api.nvim_set_keymap('n','<leader>k','<Plug>(coc-diagnostic-prev)',{})

			-- Symbol renaming
			vim.api.nvim_set_keymap('n','<leader>rn','<Plug>(coc-rename)',{})

			--			-- Auto fix
			--			vim.api.nvim_set_keymap('n','<leader>f',':CocFix<CR>',{})
			--			-- Applying code actions to the selected code block
			-- Example: `<leader>aap` for current paragraph
			vim.api.nvim_set_keymap('x','<leader>a','<Plug>(coc-codeaction-selected)',{})
			vim.api.nvim_set_keymap('n','<leader>a','<Plug>(coc-codeaction-selected)',{})
			--
			-- Remap keys for applying code actions at the cursor position
			vim.api.nvim_set_keymap('n','<leader>ac','<Plug>(coc-codeaction-cursor)',{})
			-- Remap keys for apply code actions affect whole buffer
			vim.api.nvim_set_keymap('n','<leader>as','<Plug>(coc-codeaction-source)',{})
			--			-- Apply the most preferred quickfix action to fix diagnostic on the current line
			--			vim.api.nvim_set_keymap('n','<leader>qf','<Plug>(coc-fix-current)',{})

			-- Remap keys for applying refactor code actions
			vim.api.nvim_set_keymap('n','<leader>re','<Plug>(coc-codeaction-refactor)',{silent=true})
			vim.api.nvim_set_keymap('n','<leader>re','<Plug>(coc-codeaction-refactor)',{silent=true})
			vim.api.nvim_set_keymap('x','<leader>r','<Plug>(coc-codeaction-refactor-selected)',{silent=true})
			vim.api.nvim_set_keymap('n','<leader>r','<Plug>(coc-codeaction-refactor-selected)',{silent=true})

			-- Mappings for CoCList
			-- Show all diagnostics
			vim.api.nvim_set_keymap('n','<space>a',':<C-u>CocList diagnostics<cr>',{silent=true,nowait = true})
			-- Manage extensions
			vim.api.nvim_set_keymap('n','<space>e',':<C-u>CocList extensions<cr>',{silent=true,nowait = true})
			-- Show commands
			vim.api.nvim_set_keymap('n','<space>c',':<C-u>CocList commands<cr>',{silent=true,nowait = true})
			-- Find symbol of currentdocument
			vim.api.nvim_set_keymap('n','<space>o',':<C-u>CocList outline<cr>',{silent=true,nowait = true})
			-- Search workspace symbos
			vim.api.nvim_set_keymap('n','<space>s',':<C-u>CocList -I symbols<cr>',{silent=true,nowait = true})
			-- Do default action for ext item
			vim.api.nvim_set_keymap('n','<space>j',':<C-u>CocNext<CR>',{silent=true,nowait = true})
			-- Do default action for revious iem
			vim.api.nvim_set_keymap('n','<space>k',':<C-u>CocPrev<CR>',{silent=true,nowait = true})
			-- Resume latest coc list
			vim.api.nvim_set_keymap('n','<space>p',':<C-u>CocListResume<CR>',{silent=true,nowait = true})

			-- Add status to lightline
			vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")


		end

	},

	-- NERDTree
	{
		'scrooloose/nerdtree',
		config = function()
			vim.api.nvim_set_keymap('n','<leader>nt','<cmd>NERDTreeToggle<cr>',{})
		end
	},

	{
		'tpope/vim-fugitive',
		config = function()
		end
	},

	-- vim-trailing-whitespace
	{
		'bronson/vim-trailing-whitespace',
		config = function()
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
