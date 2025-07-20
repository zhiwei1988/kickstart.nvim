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
hello

-- 自动保存设置
vim.opt.autowrite = true     -- 在切换缓冲区时自动保存
vim.opt.autowriteall = true  -- 在更多情况下自动保存

-- 设置自动保存延时为 3 秒
local autosave_timer = nil

local function autosave()
  if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
    vim.cmd("silent write")
  end
end

-- 自动保存事件，带 3 秒延时
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  callback = function()
    if autosave_timer then
      autosave_timer:stop()
    end
    autosave_timer = vim.defer_fn(autosave, 3000)  -- 3 秒延时
  end,
})

return {}
