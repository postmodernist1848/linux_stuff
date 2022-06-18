set number relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
set mouse=a
set autoindent
set softtabstop=4

filetype plugin indent on 
set encoding=utf-8 
set nocompatible 
syntax enable


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'ErichDonGubler/vim-sublime-monokai'
Plug 'tomasiser/vim-code-dark'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-scripts/AutoComplPop'
Plug 'tpope/vim-surround'
call plug#end()

colorscheme gruvbox
set background=dark 
let g:airline_powerline_fonts = 1
let g:airline#extensions#keymap#enabled = 0
let g:Powerline_symbols='unicode'
let g:airline#extensions#xkblayout#enabled = 0

set completeopt=menuone,longest
" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<Down>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Copy to clipboard with Ctrl-c or Ctrl-shift-c
vnoremap <C-S-C> "+y<Esc>

function! AirlineInit()
  let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

