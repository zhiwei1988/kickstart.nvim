return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon: add file' })
    vim.keymap.set('n', '<leader>hd', function() harpoon:list():remove() end, { desc = 'Harpoon: remove file' })
    vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: toggle menu' })
  end,
}
