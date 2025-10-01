return {
    'nvim-mini/mini.pick',
    version = '*',
    config = function()
        require("mini.pick").setup()
        vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>lq', '<cmd>Pick diagnostic<CR>', { desc = 'List functions' })
    end
}
