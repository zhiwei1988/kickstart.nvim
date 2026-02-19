return {
  'chentoast/marks.nvim',
  event = 'VimEnter',
  keys = {
    { '<leader>m', '<cmd>MarksQFListAll<cr>', desc = 'List all marks in quickfix' },
  },
  opts = {},
}
