local lsp = require('lsp-zero')

lsp.preset("recommended")

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

lsp.setup()
