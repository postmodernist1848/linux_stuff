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
Plug 'scrooloose/syntastic'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme gruvbox
set background=dark 
let g:airline_powerline_fonts = 1
let g:airline#extensions#keymap#enabled = 0
let g:Powerline_symbols='unicode'
let g:airline#extensions#xkblayout#enabled = 0

set completeopt=menuone,longest
" will insert tab at beginning of line,
" will scroll completion if not at beginning

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<Down>"
    endif
endfunction
inoremap <Tab> <Down>

" Copy to clipboard with Ctrl-c or Ctrl-shift-c
vmap <C-S-C> "+y<Esc>
nmap <F5> :w<CR>:!~/.scripts/run.sh %<CR>

" Syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
 let g:syntastic_python_python_exec = 'python3'
 let g:syntastic_python_checkers = ['python']

" A fix for powerline fonts in airline
function! AirlineInit()
  let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

