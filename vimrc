syntax enable
"If the line below is needed, uncomment line 50 && comment out 51.
"set t_Co=256
set background=light
set cursorline
set number
set expandtab
" Careful with the setting below: Makefiles require tabs (!)
"set tabstop=4
set shiftwidth=4
set autoindent
set showmatch
set incsearch
set hlsearch

set termguicolors

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree' " open/close with :NERDTree
Plug 'lervag/vimtex'
Plug 'rhysd/vim-clang-format' " select code > :ClangFormat
Plug 'sheerun/vim-polyglot'
Plug 'lifepillar/vim-solarized8'

" Disable Automatic VimTex Error Window
" The window can be toggled manually with :copen and :cclose.
let g:vimtex_quickfix_mode = 0

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

autocmd BufNewFile,BufRead *.tex set filetype=tex

" Fixing bug where files opened with Vim remain in the history.
" if &term =~ "ansi"
"     let &t_ti = "\<Esc>[?47h"
"     let &t_te = "\<Esc>[?47l"
" endif

" following systems dark/light mode
"if strftime("%H") <= 21 && strftime("%H") >= 5
"  set background=light
"else
"  set background=dark
"endif

"let g:solarized_termcolors=256 "see line 2 for more information.
colorscheme solarized8

" Close Parathesis, Brachets, etc. automatically.
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Keybindings for NERDTree.
" <C-n> means Ctrl + n btw.
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
