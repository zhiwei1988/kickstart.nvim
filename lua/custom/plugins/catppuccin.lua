return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  opts = {
    flavour = 'latte',
  },
  init = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme('catppuccin')
  end,
}
