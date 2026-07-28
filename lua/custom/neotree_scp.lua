-- neo-tree 远程 scp 命令生成（本机 Windows OpenSSH 粘贴执行）
-- gY: 远程 → %USERPROFILE%\Downloads\
-- gU: 本机路径 → 远程光标目录

local M = {}

M.WINDOWS_DOWNLOAD_DIR = '%USERPROFILE%\\Downloads\\'

--- 读取固定配置的 user@host；未配置返回 nil
function M.get_target()
  local t = vim.g.neotree_scp_target
  if type(t) == 'string' and vim.trim(t) ~= '' then
    return vim.trim(t)
  end
  return nil
end

--- 本机路径以 / 或 \ 结尾则视为目录（远程无法探测 Windows 文件系统）
function M.is_local_dir_path(path)
  if type(path) ~= 'string' or path == '' then
    return false
  end
  return path:match '[/\\]$' ~= nil
end

--- 上传远程目标目录：节点是目录用自身，文件用父目录
function M.remote_upload_dir(remote_path, is_directory)
  if is_directory then
    return remote_path
  end
  return vim.fn.fnamemodify(remote_path, ':h')
end

--- 双引号包裹；本机路径若以 \ 结尾再补一个 \，避免 "C:\foo\" 吃掉收尾引号
function M.quote(s)
  local p = s
  if p:sub(-1) == '\\' then
    p = p .. '\\'
  end
  return '"' .. p:gsub('"', '\\"') .. '"'
end

function M.build_download_cmd(target, remote_path, is_directory)
  local recursive = is_directory and '-r ' or ''
  local remote_spec = target .. ':' .. remote_path
  return string.format('scp %s%s %s', recursive, M.quote(remote_spec), M.quote(M.WINDOWS_DOWNLOAD_DIR))
end

function M.build_upload_cmd(target, local_path, remote_dir)
  local recursive = M.is_local_dir_path(local_path) and '-r ' or ''
  local dest = remote_dir
  if not dest:match '/$' then
    dest = dest .. '/'
  end
  local remote_spec = target .. ':' .. dest
  return string.format('scp %s%s %s', recursive, M.quote(local_path), M.quote(remote_spec))
end

function M.copy_to_clipboard(cmd)
  vim.fn.setreg('+', cmd)
  vim.notify('已复制: ' .. cmd)
end

function M.notify_need_target()
  vim.notify(
    '未配置 vim.g.neotree_scp_target（例如 "user@host"），无法生成 scp 命令',
    vim.log.levels.WARN
  )
end

function M.notify_multi_select(action)
  vim.notify('不支持多选，请单选后使用 ' .. action, vim.log.levels.WARN)
end

--- 从 neo-tree node 判断是否目录
function M.node_is_directory(node)
  return node and node.type == 'directory'
end

function M.node_path(node)
  if not node then
    return nil
  end
  if node.get_id then
    return node:get_id()
  end
  return node.path
end

return M
