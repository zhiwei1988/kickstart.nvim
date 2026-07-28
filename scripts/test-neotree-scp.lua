-- Unit tests for custom.neotree_scp
--
--   nvim --headless -u NONE \
--     -c "set rtp+=~/.config/nvim" \
--     -c "luafile ~/.config/nvim/scripts/test-neotree-scp.lua"

local failed = 0

local function assert_eq(name, got, want)
  if got ~= want then
    failed = failed + 1
    print(string.format('FAIL %s\n  got:  %q\n  want: %q', name, tostring(got), tostring(want)))
  else
    print('OK   ' .. name)
  end
end

local function assert_true(name, cond)
  if not cond then
    failed = failed + 1
    print('FAIL ' .. name)
  else
    print('OK   ' .. name)
  end
end

-- package path for require('custom.neotree_scp')
local cfg = vim.fn.expand '~/.config/nvim'
package.path = cfg .. '/lua/?.lua;' .. cfg .. '/lua/?/init.lua;' .. package.path

local scp = require 'custom.neotree_scp'

-- get_target
vim.g.neotree_scp_target = nil
assert_eq('get_target nil', scp.get_target(), nil)
vim.g.neotree_scp_target = ''
assert_eq('get_target empty', scp.get_target(), nil)
vim.g.neotree_scp_target = '  zhiwei@dev  '
assert_eq('get_target trim', scp.get_target(), 'zhiwei@dev')

-- is_local_dir_path
assert_true('dir trailing \\', scp.is_local_dir_path 'C:\\foo\\')
assert_true('dir trailing /', scp.is_local_dir_path 'C:/foo/')
assert_true('file no trail', not scp.is_local_dir_path 'C:\\foo\\bar.txt')
assert_true('empty not dir', not scp.is_local_dir_path '')

-- remote_upload_dir
assert_eq('upload dir self', scp.remote_upload_dir('/a/b', true), '/a/b')
assert_eq('upload file parent', scp.remote_upload_dir('/a/b/c.txt', false), '/a/b')

-- quote trailing backslash
assert_eq('quote plain', scp.quote 'hello', '"hello"')
assert_eq('quote win trail', scp.quote 'C:\\foo\\', '"C:\\foo\\\\"')

-- download
-- Downloads 以 \ 结尾，quote 会再补 \，避免 "...\Downloads\" 吃掉收尾引号
local dl_file = scp.build_download_cmd('zhiwei@dev', '/home/z/a.txt', false)
assert_eq(
  'download file',
  dl_file,
  'scp "zhiwei@dev:/home/z/a.txt" "%USERPROFILE%\\Downloads\\\\"'
)

local dl_dir = scp.build_download_cmd('zhiwei@dev', '/home/z/proj', true)
assert_eq(
  'download dir',
  dl_dir,
  'scp -r "zhiwei@dev:/home/z/proj" "%USERPROFILE%\\Downloads\\\\"'
)

-- upload
local ul_file = scp.build_upload_cmd('zhiwei@dev', 'C:\\src\\f.txt', '/home/z/in')
assert_eq(
  'upload file',
  ul_file,
  'scp "C:\\src\\f.txt" "zhiwei@dev:/home/z/in/"'
)

local ul_dir = scp.build_upload_cmd('zhiwei@dev', 'C:\\src\\folder\\', '/home/z/in')
assert_eq(
  'upload dir',
  ul_dir,
  'scp -r "C:\\src\\folder\\\\" "zhiwei@dev:/home/z/in/"'
)

if failed > 0 then
  print(string.format('\n%d test(s) failed', failed))
  vim.cmd('cquit 1')
else
  print '\nall passed'
  vim.cmd 'qa'
end
