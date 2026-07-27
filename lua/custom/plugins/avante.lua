return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    mode = 'agentic',
    provider = 'deepseek',
    auto_suggestions_provider = 'deepseek_flash',
    behaviour = {
      auto_suggestions = true,
    },
    providers = {
      -- 主对话 / agent：DeepSeek V4 Pro + Thinking（API 默认 effort=high）
      -- 注：avante openai 路径会剥离非 o1 模型的 reasoning_effort，故不显式传；
      --     DeepSeek 官方默认 thinking=enabled、effort=high，与需求一致。
      deepseek = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        api_key_name = 'DEEPSEEK_API_KEY',
        model = 'deepseek-v4-pro',
        timeout = 120000,
        extra_request_body = {
          max_tokens = 16384,
          thinking = { type = 'enabled' },
        },
      },
      -- 自动补全：Flash + Non-Thinking，低延迟短输出
      deepseek_flash = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        api_key_name = 'DEEPSEEK_API_KEY',
        model = 'deepseek-v4-flash',
        timeout = 8000,
        extra_request_body = {
          temperature = 0,
          max_tokens = 512,
          thinking = { type = 'disabled' },
        },
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  },
}
