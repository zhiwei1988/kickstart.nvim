-- Regression: neo-tree open + close current buffer must keep an editor window.
--
--   nvim --headless -u ~/.config/nvim/init.lua \
--     -c "luafile ~/.config/nvim/scripts/test-buffer-close-neotree.lua"
--
-- Exit 0 = pass, 1 = only-neotree / buffer not closed, 2 = setup failure

local root = vim.fn.tempname()
vim.fn.mkdir(root, 'p')
local f1 = root .. '/f1.txt'
local f2 = root .. '/f2.txt'
vim.fn.writefile({ 'one' }, f1)
vim.fn.writefile({ 'two' }, f2)

local function wait(ms)
  vim.wait(ms, function()
    return false
  end)
end

local function count_editor_wins()
  local n = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= 'neo-tree' then
      n = n + 1
    end
  end
  return n
end

local function focus_editor()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= 'neo-tree' then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

pcall(function()
  require('lazy').load { plugins = { 'bufferline.nvim' } }
end)
wait(200)

local map
for _ = 1, 60 do
  for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
    if m.lhs == ' x' and (m.desc or ''):find('close') and m.callback then
      map = m
      break
    end
  end
  if map then
    break
  end
  wait(50)
end

if not map then
  print('[FAIL] <leader>x Buffer: close mapping missing')
  vim.cmd('cquit 2')
  return
end

vim.cmd('edit ' .. f1)
vim.cmd('edit ' .. f2)
local ok_tree, err_tree = pcall(vim.cmd, 'Neotree show left')
if not ok_tree then
  print('[FAIL] Neotree: ' .. tostring(err_tree))
  vim.cmd('cquit 2')
  return
end
wait(300)
focus_editor()
vim.cmd('edit ' .. f2)

local target = vim.api.nvim_get_current_buf()
map.callback()
wait(100)

local listed = vim.api.nvim_buf_is_valid(target) and vim.fn.buflisted(target) == 1
local editor = count_editor_wins()

print(string.format('editor_wins=%d target_listed=%s wins=%d', editor, tostring(listed), #vim.api.nvim_list_wins()))
for _, win in ipairs(vim.api.nvim_list_wins()) do
  local buf = vim.api.nvim_win_get_buf(win)
  print(string.format('  ft=%q name=%q', vim.bo[buf].filetype, vim.api.nvim_buf_get_name(buf)))
end

if listed then
  print('[FAIL] buffer not closed')
  vim.cmd('cquit 1')
elseif editor == 0 then
  print('[FAIL] UI only neo-tree')
  vim.cmd('cquit 1')
else
  print('[PASS] buffer closed, editor window kept')
  vim.cmd('qa')
end
