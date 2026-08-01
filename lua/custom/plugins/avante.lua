return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    mode = 'agentic',
    provider = 'deepseek',
    auto_suggestions_provider = 'deepseek_flash',
    -- 全局系统提示词：强制用简体中文回答，且不展示思考过程
    system_prompt = '你是一名资深软件工程师。请始终使用简体中文回答用户的问题，直接给出最终答案，不要输出任何思考过程。',
    -- DeepSeek V4 对 tool calls 支持不完善，禁用高危工具
    disabled_tools = { 'bash', 'python' },
    behaviour = {
      auto_suggestions = true,
    },
    providers = {
      -- 主对话 / agent：DeepSeek V4 Flash，启用 Thinking（思考不显示在对话框中）
      deepseek = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        api_key_name = 'DEEPSEEK_API_KEY',
        model = 'deepseek-v4-flash',
        timeout = 120000,
        extra_request_body = {
          max_tokens = 16384,
          thinking = { type = 'enabled' },
        },
        -- 覆盖 openai provider 的 add_thinking_message：
        -- 思考内容仍会保留在 API 上下文中（保证多轮 tool call 的思维连贯性），
        -- 但通过 visible = false 让历史消息渲染层跳过显示 "🤔 Thought content:" 块。
        add_thinking_message = function(_, ctx, text, state, opts)
          if ctx.reasoning_content == nil then
            ctx.reasoning_content = ''
          end
          ctx.reasoning_content = ctx.reasoning_content .. text
          local msg = require('avante.history.message'):new('assistant', {
            type = 'thinking',
            thinking = ctx.reasoning_content,
            signature = '',
          }, {
            state = state,
            uuid = ctx.reasoning_content_uuid,
            turn_id = ctx.turn_id,
            visible = false,
          })
          ctx.reasoning_content_uuid = msg.uuid
          if opts.on_messages_add then
            opts.on_messages_add({ msg })
          end
        end,
      },
      -- 自动补全：Flash + Non-Thinking，禁用 tools
      deepseek_flash = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        api_key_name = 'DEEPSEEK_API_KEY',
        model = 'deepseek-v4-flash',
        timeout = 8000,
        disable_tools = true,
        extra_request_body = {
          temperature = 0,
          max_tokens = 512,
          thinking = { type = 'disabled' },
        },
      },
    },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
  },
}
