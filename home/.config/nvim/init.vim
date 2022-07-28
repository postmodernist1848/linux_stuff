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

call plug#begin('~/.vim/bundle')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
set smartindent

augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
    " allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END

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
vmap <C-c> "+y<Esc>
" run run.sh with f5
ab sesset let $session =
nmap <F5> :w<CR>:split term://run.sh % $session <CR>
" Clear search highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
" Use Ex instead of Vexplorer
cnoreabbrev Ex Vexplore
" open horizontal splits at the bottom and vertical to the right
set splitbelow
set splitright
" default for c
nmap <F8> ggi#include <stdio.h><CR><CR>int main (int argc, char *argv[]) {<CR><CR>return 0;<CR>}<Esc>kkO

function! AirlineInit()
  let g:airline_section_x = airline#section#create_right(['bookmark', 'tagbar', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()


