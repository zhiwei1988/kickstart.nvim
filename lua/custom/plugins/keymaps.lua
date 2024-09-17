-- keymaps.lua

local M = {}

-- 定义一个函数来打开分屏终端
local function open_terminal()
  -- 创建一个新的水平分屏
  vim.cmd 'split'
  -- 调整新分屏的高度为10行
  vim.cmd 'resize 20'
  -- 在新分屏中打开终端
  vim.cmd 'terminal'
  -- 进入插入模式,以便立即可以在终端中输入命令
  vim.cmd 'startinsert'
end

function M.setup()
  -- 定义你的快捷键
  vim.keymap.set('n', '<leader>tt', open_terminal, { desc = 'Open terminal', noremap = true, silent = true })
  vim.keymap.set('i', 'jk', '<Esc><C-k>', { desc = 'Exit Insert Mode' })
end

return M
