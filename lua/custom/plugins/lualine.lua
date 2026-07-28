return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto',
      },
      -- tabline 交给 bufferline.nvim，此处只保留底部 statusline
    }
  end,
}
