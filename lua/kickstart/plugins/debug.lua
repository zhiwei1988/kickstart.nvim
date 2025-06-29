---@diagnostic disable: missing-fields
-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- 注释掉自动安装调试适配器的依赖
    -- 如果需要使用调试功能，请确保已经手动安装了对应的调试适配器
    -- 'williamboman/mason.nvim',
    -- 'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<F4>', dap.terminate, desc = 'Debug: Terminate' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- 注释掉 mason-nvim-dap 自动安装设置
    -- 现在需要手动安装和配置调试适配器
    -- require('mason-nvim-dap').setup {
    --   automatic_installation = true,
    --   handlers = {},
    --   ensure_installed = {
    --     'codelldb',
    --   },
    -- }

    -- 手动配置调试适配器
    -- 对于 C/C++ 调试，需要安装 codelldb
    -- 安装方法：
    -- 1. 下载 codelldb 从 https://github.com/vadimcn/vscode-lldb/releases
    -- 2. 解压到合适的目录
    -- 3. 确保 codelldb 可执行文件在 PATH 中，或者在下面的配置中指定完整路径
    
    -- 配置 codelldb 适配器（用于 C/C++/Rust 调试）
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        -- 如果 codelldb 不在 PATH 中，请指定完整路径
        -- 例如：command = '/path/to/codelldb/extension/adapter/codelldb',
        command = 'codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- 配置 C/C++ 调试
    dap.configurations.c = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    
    -- C++ 使用相同的配置
    dap.configurations.cpp = dap.configurations.c

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- 如果你需要 Go 调试功能，请确保已安装 delve 调试器
    -- 安装方法：go install github.com/go-delve/delve/cmd/dlv@latest
    -- require('dap-go').setup {
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has 'win32' == 0,
    --   },
    -- }
  end,
}
