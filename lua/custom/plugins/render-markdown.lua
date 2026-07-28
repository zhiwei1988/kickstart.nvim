return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'markdown' },
  keys = {
    { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle Markdown Render' },
  },
  opts = {
    -- Normal 下始终保持渲染；仅 Insert 时由 render_modes 整页退回源码
    anti_conceal = {
      enabled = false,
    },
  },
}
