set number relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
set mouse=a
set softtabstop=4

filetype plugin on
set encoding=utf-8 
set nocompatible 
syntax enable

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
  silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/AutoComplPop'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'akinsho/toggleterm.nvim', { 'tag': 'v1.*' }
call plug#end()
set smartindent

colorscheme gruvbox
set background=dark 
let g:airline_powerline_fonts = 1
let g:airline#extensions#keymap#enabled = 0
let g:Powerline_symbols='unicode'
let g:airline#extensions#xkblayout#enabled = 0

" netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" coc settings
let g:coc_global_extensions = [
    \ 'coc-python',
    \ 'coc-sh',
    \ 'coc-clangd', ]

set completeopt=menuone,longest
" will insert tab at beginning of line,
" will scroll completion if not at beginning

" Scroll through autocomletion with Tab
inoremap <expr> <Tab> ((pumvisible())?("\<C-n>"):("\<Tab>"))
" Copy to clipboard with Ctrl-c or Ctrl-shift-c
vmap <C-S-C> "+y<Esc>
" run run.sh with F5
nmap <F5> :w<CR>:!clear && ~/.scripts/run.sh %<CR>
" Clear search highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Use Ex instead of Vexplorer
cnoreabbrev Ex Vexplore

function! AirlineInit()
  let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()


