-- general
vim.g.mapleader = " "
local map = vim.keymap.set
map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>d", '"+d')
map("n", "<leader>tf", ':terminal<cr>')
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'List functions' })
map('n', 'gr', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'references' })<cr>", { desc = 'List functions' })
map('n', 'gd', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'definition' })<cr>", { desc = 'List functions' })
map('n', 'gT', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'type_definition' })<cr>", { desc = 'List functions' })
map('n', '<leader>fs', "<cmd>lua MiniExtra.pickers.lsp({ scope = 'workspace_symbol_live' })<cr>", { desc = 'List functions' })

map({ "n", "t" }, "<Leader>tn", "<Cmd>tabnew<CR>")
map({ "n", "t" }, "<Leader>tx", "<Cmd>tabclose<CR>")
for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

vim.keymap.set('n', '<leader>fu', function()
  require('minvim.functions.api_search').find()
end, {
  noremap = true,
  silent = true,
  desc = 'Find Async API Usages'
})

vim.keymap.set('n', '<leader>fd', function()
  require('minvim.functions.api_def').find()
end, {
  noremap = true,
  silent = true,
  desc = 'Find Async API Usages'
})
