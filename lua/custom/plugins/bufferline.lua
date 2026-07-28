return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    ---在删除 buffer 前，把仍显示它的窗口切到其它 buffer。
    ---裸 :bdelete 在 neo-tree 等侧栏布局下会直接关掉编辑窗口，导致 UI 只剩侧栏。
    ---@param bufnr integer
    ---@return integer replacement buffer id used for windows
    local function ensure_windows_leave_buf(bufnr)
      local replacement = nil

      local alt = vim.fn.bufnr '#'
      if alt > 0 and alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
        replacement = alt
      end

      if not replacement then
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if b ~= bufnr and vim.fn.buflisted(b) == 1 and vim.api.nvim_buf_is_valid(b) then
            local bt = vim.bo[b].buftype
            local ft = vim.bo[b].filetype
            if bt == '' and ft ~= 'neo-tree' then
              replacement = b
              break
            end
          end
        end
      end

      if not replacement then
        replacement = vim.api.nvim_create_buf(true, false)
      end

      for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
        vim.api.nvim_win_set_buf(win, replacement)
      end

      return replacement
    end

    ---关闭 buffer，并保留编辑窗口（兼容 neo-tree 侧栏）
    ---@param bufnr integer|nil
    ---@param force boolean
    local function close_buffer(bufnr, force)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      if not force and vim.bo[bufnr].modified then
        vim.notify('Buffer has unsaved changes. Use <leader>X to force close.', vim.log.levels.WARN)
        return
      end

      ensure_windows_leave_buf(bufnr)

      local ok, err = pcall(function()
        if force then
          vim.cmd('bdelete! ' .. bufnr)
        else
          vim.cmd('bdelete ' .. bufnr)
        end
      end)
      if not ok then
        vim.notify('Failed to close buffer: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end

    ---安全关闭 buffer：有未保存修改时拒绝关闭
    ---@param bufnr integer|nil
    local function safe_bdelete(bufnr)
      close_buffer(bufnr, false)
    end

    ---强制关闭 buffer（丢弃未保存修改）
    ---@param bufnr integer|nil
    local function force_bdelete(bufnr)
      close_buffer(bufnr, true)
    end

    local excluded_filetypes = {
      help = true,
      qf = true,
      mason = true,
      lazy = true,
      TelescopePrompt = true,
      TelescopeResults = true,
      ['dap-repl'] = true,
      dapui_watches = true,
      dapui_stacks = true,
      dapui_breakpoints = true,
      dapui_scopes = true,
      dapui_console = true,
      notify = true,
      noice = true,
      oil = true,
      NvimTree = true,
      ['neo-tree'] = true,
      trouble = true,
      fugitive = true,
      gitcommit = true,
      Avante = true,
      AvanteInput = true,
      checkhealth = true,
    }

    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'ordinal',
        themable = true,
        diagnostics = false,
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_buffer_icons = true,
        color_icons = true,
        persist_buffer_sort = true,
        -- 打开顺序追加到末尾；手动重排后可跨 session 保持（需 sessionoptions 含 globals）
        sort_by = 'insert_at_end',
        separator_style = 'thin',
        close_command = function(bufnr)
          safe_bdelete(bufnr)
        end,
        right_mouse_command = function(bufnr)
          safe_bdelete(bufnr)
        end,
        left_mouse_command = 'buffer %d',
        middle_mouse_command = function(bufnr)
          force_bdelete(bufnr)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
        custom_filter = function(buf_number)
          local name = vim.fn.bufname(buf_number)
          if name == '' then
            return false
          end

          local ft = vim.bo[buf_number].filetype
          if excluded_filetypes[ft] then
            return false
          end

          local buftype = vim.bo[buf_number].buftype
          -- 排除 terminal / help / quickfix / nofile 等非普通文件
          if buftype ~= '' then
            return false
          end

          return true
        end,
      },
    }

    -- 相邻切换
    vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Buffer: previous' })
    vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Buffer: next' })

    -- 按顶栏序号跳转
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        require('bufferline').go_to(i, true)
      end, { desc = 'Buffer: go to ' .. i })
    end

    -- 关闭：安全 / 强制
    vim.keymap.set('n', '<leader>x', function()
      safe_bdelete()
    end, { desc = 'Buffer: close (safe)' })
    vim.keymap.set('n', '<leader>X', function()
      force_bdelete()
    end, { desc = 'Buffer: close (force)' })

    -- 手动重排（bufferline 无原生拖拽时用键盘移动；顺序会 persist）
    vim.keymap.set('n', '<leader><', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Buffer: move left' })
    vim.keymap.set('n', '<leader>>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Buffer: move right' })
  end,
}
