-- set space as the leader key
vim.g.mapleader = " "

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- epic move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- make the cursor remain position
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search in the centre of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- "greatest remap ever" - Primeagen
vim.keymap.set("x", "<leader>p", "\"_dP")

-- "second greatest remap ever" - copy to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- d without destroying your registers
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- set env variable with additional arguments
vim.keymap.set("n", "<F6>", ":let $SESSION_ARGS=\"\"<Left>")
-- run run.sh with f5
vim.keymap.set("n", "<F5>", ":w<CR>:split term://run.sh %:p $SESSION_ARGS<CR>")
