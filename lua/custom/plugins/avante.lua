return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- add any opts here
    -- mode = "legacy",
    mode = "agentic",
    provider = 'gemini',
    auto_suggestions_provider = 'gemini',
    behaviour = {
      auto_suggestions = true,
    },
    gemini = {
      endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
      model = 'gemini-3-flash-preview',
      timeout = 30000,
      temperature = 0,
      max_tokens = 4096,
    },
    vendors = {
      gemini_pro = {
        endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
        model = 'gemini-3.1-pro-preview',
        timeout = 30000,
        temperature = 0,
        max_tokens = 8192,
        api_key_name = 'GEMINI_API_KEY',
        parse_curl_args = function(provider, code_opts)
          return require('avante.providers.gemini').parse_curl_args(provider, code_opts)
        end,
        parse_response_data = function(data_stream, event_state, opts)
          return require('avante.providers.gemini').parse_response(data_stream, event_state, opts)
        end,
      },
    },
  },
  keys = {
    {
      '<leader>ap',
      function() require('avante.api').switch_provider('gemini_pro') end,
      desc = 'Avante: switch to gemini pro',
    },
    {
      '<leader>af',
      function() require('avante.api').switch_provider('gemini') end,
      desc = 'Avante: switch to gemini flash',
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
