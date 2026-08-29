syntax enable
set background=light
set cursorline
set number
set expandtab
set shiftwidth=4
set autoindent
set showmatch
set incsearch
set hlsearch

colorscheme shine

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips'
Plug 'Townk/vim-autoclose'
Plug 'scrooloose/nerdtree' " open/close with :NERDTree
Plug 'lervag/vimtex'
Plug 'kaarmu/typst.vim'
Plug 'rhysd/vim-clang-format' " select code > :ClangFormat
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'prabirshrestha/vim-lsp'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Disable Automatic VimTex Error Window
" The window can be toggled manually with :copen and :cclose.
let g:vimtex_quickfix_mode = 0

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" https://github.com/vim-airline/vim-airline-themes#vim-airline-themes--
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#tabline#enabled = 1

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

" Keybindings for NERDTree.
" <C-n> means Ctrl + n btw. <CR> is a necessary suffix. Otherwise
" the command ':NERDTreeFocus' would just be added to the commandline
" and never executed because the 'Enter' equivalent would be missing.
" This is what <CR> is for. 
" <leader> is mapped to '\' by default.
"
" When selecting files press 
" 'i' to open in horizontal split
" 'v' to open in vertical split
" 't' to open in new tab
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" Autocompletion via asyncomplete
" 
" For C++ you might have to rerun the following from time to time:
"
" cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
" ln -s build/compile_commands.json .
function! s:register(name, cmd, filetypes) abort
  if executable(a:cmd[0])
    call lsp#register_server({
      \ 'name': a:name,
      \ 'cmd': {server_info->a:cmd},
      \ 'allowlist': a:filetypes,
      \ })
  endif
endfunction
"
augroup lsp_servers
  au!
  au User lsp_setup call s:register('rust-analyzer', ['rust-analyzer'], ['rust'])
  au User lsp_setup call s:register('clangd', ['clangd', '--background-index'], ['c', 'cpp', 'objc'])
  au User lsp_setup call s:register('pyright', ['pyright-langserver', '--stdio'], ['python'])
  au User lsp_setup call s:register('elixir-ls', ['elixir-ls'], ['elixir', 'eelixir'])
  au User lsp_setup call s:register('jdtls',
  \ ['jdtls', '-data', expand('~/.cache/jdtls/') . fnamemodify(getcwd(), ':t')],
  \ ['java'])
augroup END

" Enable Scroll in windows within Lsp
"
" scroll up with C-d
" scroll down with C-f
nnoremap <buffer> <expr> <C-f> lsp#scroll(+4)
nnoremap <buffer> <expr> <C-d> lsp#scroll(-4)
