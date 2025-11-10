return {
    'nvim-mini/mini.pick',
    version = '*',
    config = function()
        require("mini.pick").setup({
            mappings = {
                caret_left        = '<Left>',
                caret_right       = '<Right>',

                choose            = '<CR>',
                choose_in_split   = '',
                choose_in_tabpage = '<C-t>',
                choose_in_vsplit  = '<C-v>',
                choose_marked     = '<C-s>',

                delete_char       = '<BS>',
                delete_char_right = '<Del>',
                delete_left       = '<C-u>',
                delete_word       = '<C-w>',

                mark              = '<C-x>',
                mark_all          = '<C-a>',

                move_down         = '<C-n>',
                move_start        = '<C-g>',
                move_up           = '<C-p>',

                paste             = '<C-r>',

                refine            = '<C-Space>',
                refine_marked     = '<M-Space>',

                scroll_down       = '<C-f>',
                scroll_left       = '<C-h>',
                scroll_right      = '<C-l>',
                scroll_up         = '<C-b>',

                stop              = '<Esc>',

                toggle_info       = '<S-Tab>',
                toggle_preview    = '<Tab>',
            },
        })
        vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers<CR>', { desc = 'List functions' })
        vim.keymap.set('n', '<leader>lq', '<cmd>Pick diagnostic<CR>', { desc = 'List functions' })
    end
}
