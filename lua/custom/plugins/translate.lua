return {
  'zhiwei1988/translate.nvim',
  keys = {
    { '<leader>tr', '<Plug>(translate)', mode = 'n', desc = '翻译当前段落' },
    { '<leader>tr', '<Plug>(translate-selection)', mode = 'x', desc = '翻译选区' },
  },
  opts = {
    provider = 'deepseek',
  },
}
