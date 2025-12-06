return {
  'shaunsingh/solarized.nvim',
  lazy = false, -- 确保在启动时加载
  priority = 1000, -- 确保主题在其他插件之前加载
  init = function()
    -- 设置 light 模式（如果需要 dark 模式，可以设置为 'dark' 或不设置）
    vim.g.solarized_style = 'light'
    vim.opt.termguicolors = true
    -- 加载 colorscheme
    vim.cmd.colorscheme('solarized')
  end,
}
