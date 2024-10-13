-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- [[Custom Setting Options]]

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- 使用空格替换Tab
vim.opt.expandtab = true

-- 设置系统剪切板工具
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

return {}
