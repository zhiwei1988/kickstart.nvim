return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- legacy 模式：编辑通过 sidebar apply 落地（模型返回代码块/diff，用户确认后写入缓冲区），
    -- 不依赖 LLM 工具调用，因此与模型名无关，GLM 只要返回合规的 Anthropic Messages 文本即可用。
    -- agentic 模式对 GLM 不可用：avante 会在 agentic 下把自带编辑工具从 tools 列表剔除，
    -- 改注入 Anthropic 服务端 text_editor，但 text_editor 仅在 model 匹配 claude-* 前缀时才注入，
    -- glm-5.2 不匹配 → 模型拿不到任何文件编辑工具。
    mode = 'legacy',
    provider = 'deepseek',
    auto_suggestions_provider = 'deepseek_flash',

    behaviour = {
      auto_suggestions = false,
    },
    providers = {
      glm = {
        -- 公司内部自部署的 GLM（严格兼容 Anthropic Messages API，含工具调用）。
        -- 继承 avante 内置 claude provider：复用其 parse_curl_args/parse_response/parse_api_key，
        -- 仅覆盖 endpoint/model 与认证头。端点与 token 取自环境变量，换值无需改本文件。
        __inherited_from = 'claude',
        endpoint = vim.env.ANTHROPIC_BASE_URL or 'http://localhost:3100',
        model = vim.env.ANTHROPIC_DEFAULT_SONNET_MODEL or 'glm-5.2',
        timeout = 30000,
        -- avante 内置 claude provider 在 auth_type=="api" 时只发 x-api-key（claude.lua:591），
        -- 没有 Authorization: Bearer。GLM 网关用 Bearer 鉴权，故调用继承来的 parse_curl_args
        -- 构造完整请求后，把认证头改为 Bearer 并清掉 x-api-key。
        -- 用 __inherited_from 继承时，本函数以 method 形式被调用（provider:parse_curl_args），
        -- 第一参数 self 是合并后的 provider 实例；先调原始 claude method 拿完整 curl_args 再改 headers。
        api_key_name = 'ANTHROPIC_AUTH_TOKEN',
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
        parse_curl_args = function(self, code_opts)
          local Utils = require('avante.utils')
          -- 调用继承自 claude 的原始实现，拿到完整 url/body/tools/system/headers
          local curl_args = require('avante.providers.claude').parse_curl_args(self, code_opts)
          if curl_args and curl_args.headers then
            local token = vim.env.ANTHROPIC_AUTH_TOKEN or ''
            if token == '' then
              Utils.error('Avante(GLM): ANTHROPIC_AUTH_TOKEN 未设置，请先 export ANTHROPIC_AUTH_TOKEN=<your-token>')
            else
              curl_args.headers['Authorization'] = 'Bearer ' .. token
              -- 清掉内置 claude provider 写入的 x-api-key，避免网关按 x-api-key 鉴权失败
              curl_args.headers['x-api-key'] = nil
            end
          end
          return curl_args
        end,
      },
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
