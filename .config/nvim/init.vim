let mapleader = ","

set tabstop=4
set shiftwidth=4
autocmd BufWinLeave *.md mkview
autocmd BufWinEnter *.md silent loadview
set expandtab
syntax on
colorscheme monokai

set ai "Auto indent
set si "Smart indent
set smarttab " Be smart when using tabs ;)
set wrap "Wrap line
set number
set relativenumber
set incsearch
set incsearch " Search as typing
set hlsearch " Highlight search results
set cursorline " Highlight the cursor line
set virtualedit=onemore " Allow the cursor to move just past the end of the line
set scrolloff=10 " Always keep 10 lines after or before when scrolling
set gdefault " The substitute flag g is on
set showbreak=↪ " See this char when wrapping text
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set ignorecase " Search insensitive
set smartcase " ... but smart
set guicursor="" " Keep terminal emulator defined GUI cursor style
set mouse=a
"Disable mouse integration
set spelllang=en_us



""" Prevent lag when hitting escape
set ttimeoutlen=0
set timeoutlen=1000
au InsertEnter * set timeout
au InsertLeave * set notimeout

" Useful command to copy and delete buffer
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Left and right can switch buffers
nnoremap <C-left> :bp<CR>
nnoremap <C-right> :bn<CR>

" <leader><leader> toggles between buffers
nnoremap ,, <c-^>
nnoremap <leader><space> :noh<cr>

" Set to auto read when a file is changed from the outside
set autoread

" For regular expressions turn magic on
set magic

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Make backspace behave in a sane manner
set backspace=2
set backspace=indent,eol,start

" Fix laggy scroll
set lazyredraw
set ttyfast

""" Custom commands

" :W - To write with root rights
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
	if &paste
		return 'PASTE MODE  '
	endif
	return ''
endfunction

" Airline stuff
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#checks = [ 'trailing' ]

" Highlight columns
let &colorcolumn="80,100""

" Clear search buffer
nnoremap <leader><space> :noh<cr>
" Re-select pasted text
nnoremap <leader>v V`]
" Automagically inserts \end in LaTeX with proper contents
nnoremap <leader>end o\end{}<esc>/\\begin<enter>Nf{lyt}/\\end<enter>f{p<esc><leader><space>k
" Delete without putting into the yank register
nnoremap <leader>d "_d
" Tabularize with commas
nnoremap <leader>zs :'<,'>Tabularize /,\zs<cr>

" Toggle NERDTree
nnoremap <leader>nt :NERDTreeToggle<enter>

" Create sequence of numbers from a ^A on a vblock of numbers
function! Incr()
	let a = line('.') - line("'<")
	let c = virtcol("'<")
	if a > 0
		execute 'normal! '.c.'|'.a."\<C-a>"
	endif
	normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

" Plugins
call plug#begin('~/.vim/plugged')

" Airline statusbar
Plug 'vim-airline/vim-airline'

" Polyglot addons
Plug 'sheerun/vim-polyglot'

" Indent guides
" Plug 'nathanaelkane/vim-indent-guides'

" Better (?) indent guides
Plug 'Yggdroot/indentLine'

" Git modifications in the gutter
Plug 'airblade/vim-gitgutter'

" Alignment plugin
" Plug 'godlygeek/tabular'

" File tree
Plug 'scrooloose/nerdtree'

" Nerdtree git integration
Plug 'Xuyuanp/nerdtree-git-plugin'

" Better JSON handling
Plug 'elzr/vim-json'

" Highlight trailing whitespaces
Plug 'bronson/vim-trailing-whitespace'

" Automatically inserts matching pair
Plug 'jiangmiao/auto-pairs'

" Table Mode
Plug 'dhruvasagar/vim-table-mode'

" Edit PNGs ? WTF ?
Plug 'tpope/vim-afterimage'

"Tabularize
Plug 'godlygeek/tabular'

" Cisco colors
Plug 'momota/cisco.vim'

Plug 'crusoexia/vim-monokai'

" Easy align stuff
Plug 'junegunn/vim-easy-align'


" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
" or                                , { 'branch': '0.1.x'}
" File explorer
Plug 'nvim-tree/nvim-tree.lua'

Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if has('nvim')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

call plug#end()

"Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep hidden=true<cr>
nnoremap <leader>fb <cmd>Telescope buffers hidden=true<cr>
nnoremap <leader>fh <cmd>Telescope help_tags hidden=true<cr>

nnoremap <leader>Ag <cmd>Ag<cr>
nnoremap <leader>Rg <cmd>Rg<cr>

nnoremap <Leader>b :Buffers<CR>

" Tab guides
set listchars=tab:\│\
set list
hi SpecialKey ctermfg=240 ctermbg=NONE
if has('nvim')
	hi Nontext ctermfg=240 ctermbg=NONE
endif

" Indent guides, spaces
let g:indentLine_char='│'
let g:indentLine_color_term=240

" Change the vim shell for syntastic (can't handle fish)
set shell=bash

" Use clang-format
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

" NERDTree filetype ignore
let NERDTreeIgnore=['\.pyc']

if has('nvim')
	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	nmap <silent> <Leader>j <Plug>(coc-diagnostic-next-error)
	nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev-error)
	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Auto fix
	nmap <leader>f :CocFix<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> M :call ShowMoreDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

function! ShowMoreDocumentation()
    if coc#float#has_float()
      call coc#float#jump()
      nnoremap <buffer> q <Cmd>close<CR>
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
"
" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

endif

let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1
