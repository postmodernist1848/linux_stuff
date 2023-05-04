vim.cmd [[
augroup neovim_terminal
    autocmd!
    " enter terminal-mode (insert) automatically
    autocmd termopen * startinsert
    " disables number lines on terminal buffers
    autocmd termopen * :set nonumber norelativenumber
    " allows you to use ctrl-c on terminal window
    autocmd termopen * nnoremap <buffer> <c-c> i<c-c>
augroup end 
]]

vim.cmd [[tnoremap <esc> <c-\><c-n>]]
vim.keymap.set("", "<F7>", ":let $VIM_DIR=expand('%:p:h') | split | terminal<CR>cd $VIM_DIR && clear<CR>")

