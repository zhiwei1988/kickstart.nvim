return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' }, -- 在打开或创建文件时加载
  opts = {
    -- 显示行修改状态
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },

    current_line_blame_opts = {
      -- blame 信息显示延迟（毫秒）
      delay = 1000,
    },

    -- 开启当前行 blame
    current_line_blame = true,

    -- blame 信息格式
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

    -- 设置预览窗口的位置
    preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
  },
  keys = {
    -- 键位映射
    { '<leader>hb', ':Gitsigns blame_line<CR>', desc = 'Git blame line' },
    { '<leader>hp', ':Gitsigns preview_hunk<CR>', desc = 'Git preview hunk' },
    { '<leader>hs', ':Gitsigns stage_hunk<CR>', desc = 'Git stage hunk' },
    { '<leader>hr', ':Gitsigns reset_hunk<CR>', desc = 'Git reset hunk' },
    { '<leader>hu', ':Gitsigns undo_stage_hunk<CR>', desc = 'Git undo stage hunk' },
    { ']c', ':Gitsigns next_hunk<CR>', desc = 'Next git hunk' },
    { '[c', ':Gitsigns prev_hunk<CR>', desc = 'Previous git hunk' },
  },
}
