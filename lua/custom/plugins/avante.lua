return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
    -- mode = "legacy",
    mode = "agentic",
    provider = 'gemini_pro',
    auto_suggestions_provider = 'gemini_flash',
    behaviour = {
      auto_suggestions = true,
    },
    providers = {
      gemini_pro = {
        __inherited_from = 'gemini',
        endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
        model = 'gemini-3-pro-preview',
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
        api_key_name = 'GEMINI_API_KEY',
      },
      gemini_flash = {
        __inherited_from = 'gemini',
        endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
        model = 'gemini-3-flash-preview',
        timeout = 30000,
        temperature = 0,
        max_tokens = 2048,
        api_key_name = 'GEMINI_API_KEY',
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
