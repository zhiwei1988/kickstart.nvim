-- diffview.nvim 配置 - Git diff 可视化工具

---逐字节校验字符串是否为合法 UTF-8。
---diffview 的历史版本 pane 会把 git blob 的原始字节不经转码塞进 buffer；
---GBK 文件的字节不是合法 utf-8，借此判定需要按 GBK 重解码。
---@param s string
---@return boolean
local function is_valid_utf8(s)
  local i, n = 1, #s
  while i <= n do
    local b = string.byte(s, i)
    if b < 0x80 then
      i = i + 1
    elseif b >= 0xC2 and b <= 0xDF then
      local b2 = string.byte(s, i + 1)
      if not (b2 and b2 >= 0x80 and b2 <= 0xBF) then
        return false
      end
      i = i + 2
    elseif b >= 0xE0 and b <= 0xEF then
      local b2, b3 = string.byte(s, i + 1), string.byte(s, i + 2)
      if b == 0xE0 then
        if not (b2 and b2 >= 0xA0 and b2 <= 0xBF and b3 and b3 >= 0x80 and b3 <= 0xBF) then
          return false
        end
      elseif b >= 0xE1 and b <= 0xEC then
        if not (b2 and b2 >= 0x80 and b2 <= 0xBF and b3 and b3 >= 0x80 and b3 <= 0xBF) then
          return false
        end
      elseif b == 0xED then
        if not (b2 and b2 >= 0x80 and b2 <= 0x9F and b3 and b3 >= 0x80 and b3 <= 0xBF) then
          return false
        end
      else -- 0xEE-0xEF
        if not (b2 and b2 >= 0x80 and b2 <= 0xBF and b3 and b3 >= 0x80 and b3 <= 0xBF) then
          return false
        end
      end
      i = i + 3
    elseif b >= 0xF0 and b <= 0xF4 then
      local b2, b3, b4 = string.byte(s, i + 1), string.byte(s, i + 2), string.byte(s, i + 3)
      if b == 0xF0 then
        if not (b2 and b2 >= 0x90 and b2 <= 0xBF and b3 and b3 >= 0x80 and b3 <= 0xBF and b4 and b4 >= 0x80 and b4 <= 0xBF) then
          return false
        end
      elseif b >= 0xF1 and b <= 0xF3 then
        if not (b2 and b2 >= 0x80 and b2 <= 0xBF and b3 and b3 >= 0x80 and b3 <= 0xBF and b4 and b4 >= 0x80 and b4 <= 0xBF) then
          return false
        end
      else -- 0xF4
        if not (b2 and b2 >= 0x80 and b2 <= 0x8F and b3 and b3 >= 0x80 and b3 <= 0xBF and b4 and b4 >= 0x80 and b4 <= 0xBF) then
          return false
        end
      end
      i = i + 4
    else
      -- 0x80-0xC1: 孤立的续字节或非法首字节
      return false
    end
  end
  return true
end

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

          -- GBK 文件乱码修复
          -- diffview 用 `git show <rev>:<path>` 取历史版本字节，经 plenary Job 直接
          -- nvim_buf_set_lines 塞进 buffer，全程不做编码转换（见 diffview
          -- vcs/adapter.lua VCSAdapter.show + vcs/file.lua:289）。而 nvim buffer 内部
          -- 编码固定 utf-8，fileencodings 自动探测只对"读文件"生效、对 set_lines 塞入的
          -- 原始字节无效——于是 GBK 文件的历史版本 pane 会把 GBK 字节当 utf-8 渲染成 mojibake。
          -- 修复：buffer 含非法 utf-8 字节时，判定为 GBK 系，按 gb18030(GBK 超集) 逐行
          -- 重解码回填。合法 utf-8 的文件原样不动，零误伤（真 utf-8 不会被当 GBK 破坏）。
          local ok, converted = pcall(function()
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            if not lines or #lines == 0 then
              return nil
            end
            -- 拼成整串做一次合法性判定（跨行的多字节序列在此 repo 不会出现：C 文件每行独立）
            local blob = table.concat(lines, '\n')
            if is_valid_utf8(blob) then
              return nil -- 合法 utf-8，无需转码
            end
            -- 逐行 gb18030 -> utf-8；iconv 对无法解码的字节会丢弃，但 GBK 整行注释能完整还原
            local out = {}
            for _, line in ipairs(lines) do
              out[#out + 1] = vim.fn.iconv(line, 'gb18030', 'utf-8')
            end
            return out
          end)
          if ok and converted then
            vim.bo[bufnr].modifiable = true
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, converted)
            vim.bo[bufnr].modifiable = false
            vim.bo[bufnr].modified = false
          elseif not ok then
            vim.notify('diffview GBK 修复失败: ' .. tostring(converted), vim.log.levels.WARN)
          end
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          -- 进入 diff 缓冲区窗口时调用
          -- 可以设置窗口特定的选项
          vim.opt_local.scrollbind = true -- 强制同步滚动
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
