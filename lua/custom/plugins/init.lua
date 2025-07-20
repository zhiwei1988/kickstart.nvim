-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- [[Custom Setting Options]]

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 使用空格替换Tab
vim.opt.expandtab = true

if vim.fn.executable 'clipboard-provider' then
  vim.g.clipboard = {
    name = 'myClipboard',
    copy = {
      ['+'] = 'clipboard-provider copy',
      ['*'] = 'env COPY_PROVIDERS=tmux clipboard-provider copy',
    },
    paste = {
      ['+'] = 'clipboard-provider paste',
      ['*'] = 'env COPY_PROVIDERS=tmux clipboard-provider paste',
    },
  }
end

-- 使用 treesitter 进行折叠
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- 默认不折叠
vim.wo.foldlevel = 99

-- 设置内部编码为 utf-8
vim.opt.encoding = 'utf-8'
-- 设置文件编码为 utf-8
vim.opt.fileencoding = 'utf-8'
-- 设置自动检测的编码列表
vim.opt.fileencodings = 'utf-8,gb2312'

return {}
