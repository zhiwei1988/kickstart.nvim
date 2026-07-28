return {
  'selimacerbas/markdown-preview.nvim',
  dependencies = { 'selimacerbas/live-server.nvim' },
  -- 模块名是 markdown_preview（下划线），不是 markdown-preview
  main = 'markdown_preview',
  ft = { 'markdown', 'mermaid' },
  cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewRefresh' },
  keys = {
    {
      '<leader>tp',
      function()
        local mp = require 'markdown_preview'
        -- 预览活跃时会挂 autocmd 组；secondary takeover 时也可能没有 server 实例
        if mp._augroup or mp._server_instance then
          mp.stop()
        else
          mp.start()
        end
      end,
      desc = 'Toggle Markdown Browser Preview',
      ft = { 'markdown', 'mermaid' },
    },
  },
  opts = {
    default_theme = 'light',
    mermaid_renderer = 'js',
    -- 本机自动开浏览器；SSH 时只通知 URL（配合 hooks）
    open_browser = vim.env.SSH_TTY == nil,
    hooks = {
      on_start = function(url)
        if vim.env.SSH_TTY then
          vim.notify('Markdown Preview: ' .. url, vim.log.levels.INFO)
        end
      end,
    },
  },
}
