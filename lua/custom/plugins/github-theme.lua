return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  init = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme('github_light_colorblind')
  end,
}
