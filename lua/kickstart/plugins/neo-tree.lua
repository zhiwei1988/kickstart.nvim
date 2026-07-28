-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local scp = require 'custom.neotree_scp'

--- 复制「远程 → 本机 Downloads」scp 命令
local function scp_download(state)
  local target = scp.get_target()
  if not target then
    scp.notify_need_target()
    return
  end
  local node = state.tree:get_node()
  local path = scp.node_path(node)
  if not path then
    vim.notify('无法获取节点路径', vim.log.levels.WARN)
    return
  end
  local cmd = scp.build_download_cmd(target, path, scp.node_is_directory(node))
  scp.copy_to_clipboard(cmd)
end

local function scp_download_visual(state, selected_nodes)
  if not selected_nodes or #selected_nodes ~= 1 then
    scp.notify_multi_select 'gY'
    return
  end
  local target = scp.get_target()
  if not target then
    scp.notify_need_target()
    return
  end
  local node = selected_nodes[1]
  local path = scp.node_path(node)
  if not path then
    vim.notify('无法获取节点路径', vim.log.levels.WARN)
    return
  end
  local cmd = scp.build_download_cmd(target, path, scp.node_is_directory(node))
  scp.copy_to_clipboard(cmd)
end

--- 复制「本机 → 远程光标目录」scp 命令（input 填本机路径）
local function scp_upload(state)
  local target = scp.get_target()
  if not target then
    scp.notify_need_target()
    return
  end
  local node = state.tree:get_node()
  local path = scp.node_path(node)
  if not path then
    vim.notify('无法获取节点路径', vim.log.levels.WARN)
    return
  end
  local remote_dir = scp.remote_upload_dir(path, scp.node_is_directory(node))

  vim.ui.input({
    prompt = '本机源路径 (目录请以 \\ 或 / 结尾): ',
  }, function(local_path)
    if not local_path or vim.trim(local_path) == '' then
      return
    end
    local cmd = scp.build_upload_cmd(target, vim.trim(local_path), remote_dir)
    scp.copy_to_clipboard(cmd)
    vim.notify('上传完成后可在 neo-tree 按 R 刷新', vim.log.levels.INFO)
  end)
end

local function scp_upload_visual(state, selected_nodes)
  if not selected_nodes or #selected_nodes ~= 1 then
    scp.notify_multi_select 'gU'
    return
  end
  -- 复用单选逻辑：临时把光标语义落到唯一选中节点
  local node = selected_nodes[1]
  local target = scp.get_target()
  if not target then
    scp.notify_need_target()
    return
  end
  local path = scp.node_path(node)
  if not path then
    vim.notify('无法获取节点路径', vim.log.levels.WARN)
    return
  end
  local remote_dir = scp.remote_upload_dir(path, scp.node_is_directory(node))
  vim.ui.input({
    prompt = '本机源路径 (目录请以 \\ 或 / 结尾): ',
  }, function(local_path)
    if not local_path or vim.trim(local_path) == '' then
      return
    end
    local cmd = scp.build_upload_cmd(target, vim.trim(local_path), remote_dir)
    scp.copy_to_clipboard(cmd)
    vim.notify('上传完成后可在 neo-tree 按 R 刷新', vim.log.levels.INFO)
  end)
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    -- monorepo：git status 只算当前 neo-tree 显示路径，避免全仓扫描
    git_status_scope_to_path = true,
    commands = {
      scp_download = scp_download,
      scp_download_visual = scp_download_visual,
      scp_upload = scp_upload,
      scp_upload_visual = scp_upload_visual,
    },
    filesystem = {
      -- 用 OS 级文件监视自动刷新目录树与 git 状态（外部改动可跟上）
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- 复制文件名 / 路径（多种格式）
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              ['文件名'] = filename,
              ['绝对路径'] = path,
              ['相对路径'] = modify(path, ':.'),
              ['家目录相对路径'] = modify(path, ':~'),
            }

            local options = vim.tbl_keys(results)
            table.sort(options)

            vim.ui.select(options, {
              prompt = '选择要复制的内容:',
              format_item = function(item)
                return ('%s: %s'):format(item, results[item])
              end,
            }, function(choice)
              local result = results[choice]
              if result then
                vim.fn.setreg('+', result)
                vim.notify('已复制: ' .. result)
              end
            end)
          end,
          -- 复制 scp 下载命令（远程 → 本机 Downloads）
          ['gY'] = 'scp_download',
          -- 复制 scp 上传命令（本机 → 远程光标目录）
          ['gU'] = 'scp_upload',
        },
      },
    },
  },
}
