-- diffview.nvim 配置 - Git diff 可视化工具
return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- 可选，用于显示文件图标
  },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  keys = {
    -- Git diff 相关快捷键
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '打开 Git Diff 视图' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '查看当前文件的 Git 历史' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '查看整个项目的 Git 历史' },
    { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = '关闭 Diff 视图' },
    { '<leader>gf', '<cmd>DiffviewToggleFiles<cr>', desc = '切换文件面板显示' },
  },
  config = function()
    require('diffview').setup({
      -- 差异显示配置
      diff_binaries = false, -- 不显示二进制文件的差异
      enhanced_diff_hl = false, -- 使用增强的差异高亮
      git_cmd = { 'git' }, -- Git 命令
      use_icons = true, -- 使用图标

      -- 图标配置
      icons = {
        folder_closed = '',
        folder_open = '',
      },

      -- 符号配置
      signs = {
        fold_closed = '',
        fold_open = '',
        done = '✓',
      },

      -- 视图配置
      view = {
        -- 配置默认布局
        default = {
          -- 可用的布局: 'diff2_horizontal', 'diff2_vertical', 'diff3_horizontal',
          -- 'diff3_vertical', 'diff3_mixed', 'diff4_mixed'
          layout = 'diff2_horizontal',
          winbar_info = false, -- 在 winbar 中显示信息 (需要 nvim-0.8+)
        },
        merge_tool = {
          -- 合并工具的布局配置
          layout = 'diff3_horizontal',
          disable_diagnostics = true, -- 在合并工具中禁用诊断
          winbar_info = true, -- 在 winbar 中显示信息 (需要 nvim-0.8+)
        },
        file_history = {
          -- 文件历史视图的布局配置
          layout = 'diff2_horizontal',
          winbar_info = false, -- 在 winbar 中显示信息 (需要 nvim-0.8+)
        },
      },

      -- 文件面板配置
      file_panel = {
        listing_style = 'tree', -- 可选: 'list' 或 'tree'
        tree_options = {
          flatten_dirs = true, -- 扁平化空目录
          folder_statuses = 'only_folded', -- 可选: 'never', 'only_folded' 或 'always'
        },
        win_config = {
          -- 文件面板窗口配置
          position = 'left', -- 可选: 'left', 'right', 'top', 'bottom'
          width = 35, -- 只适用于左右位置
          height = 10, -- 只适用于上下位置
          win_opts = {}
        },
      },

      -- 文件历史面板配置
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = 'combined',
            },
            multi_file = {
              diff_merges = 'first-parent',
            },
          },
        },
        win_config = {
          position = 'bottom',
          height = 16,
          win_opts = {}
        },
      },

      -- 提交日志面板配置
      commit_log_panel = {
        win_config = {
          position = 'bottom',
          height = 16,
          win_opts = {}
        }
      },

      -- 默认参数
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },

      -- 钩子配置
      hooks = {
        diff_buf_read = function(bufnr)
          -- 在读取 diff 缓冲区后调用
          -- 可以在这里设置特定于 diff 视图的选项
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = '80'
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          -- 进入 diff 缓冲区窗口时调用
          -- 可以设置窗口特定的选项
          if ctx.layout_name:match('^diff2') then
            if ctx.symbol == 'a' then
              vim.opt_local.winhl = table.concat({
                'DiffAdd:DiffviewDiffAddAsDelete',
                'DiffDelete:DiffviewDiffDelete',
              }, ',')
            elseif ctx.symbol == 'b' then
              vim.opt_local.winhl = table.concat({
                'DiffDelete:DiffviewDiffDelete',
              }, ',')
            end
          end
        end,
      },
    })
  end,
}