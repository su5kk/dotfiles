return {
    'nvim-mini/mini.pick',
    version = '*',
    config = function()
        require("mini.pick").setup()
        vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fb', '<cmd>Pick diagnostic<CR>', { desc = 'List functions' })
        vim.keymap.set('n', 'gr', '<cmd>Pick lsp scope=\'references\'<CR>', { desc = 'List functions' })
    end
}
