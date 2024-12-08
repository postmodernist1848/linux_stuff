vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- g is the default when using s Ex command (reversed now)
vim.opt.gdefault = true

vim.opt.scrolloff = 5

vim.opt.termguicolors = true

-- backup time
vim.opt.updatetime = 1000

--vim.opt.signcolumn = "yes"
vim.api.nvim_create_autocmd(
    {
        "BufNewFile",
        "BufRead",
    },
    {
        pattern = "*.fs,*.vs",
        callback = function()
            vim.bo.filetype = "glsl"
        end
    }
)
