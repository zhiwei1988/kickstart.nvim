return {
  'nordtheme/vim',
  name = 'nord',
  lazy = false,
  priority = 1000,
  init = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme('nord')
  end,
}
