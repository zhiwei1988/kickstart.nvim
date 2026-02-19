-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

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
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          -- 绑定 Y 键触发自定义函数
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              ["文件名"] = filename,
              ["绝对路径"] = path,
              ["相对路径"] = modify(path, ":."),
              ["家目录相对路径"] = modify(path, ":~"),
            }

            local options = vim.tbl_keys(results)
            table.sort(options)
            
            vim.ui.select(options, {
              prompt = "选择要复制的内容:",
              format_item = function(item)
                return ("%s: %s"):format(item, results[item])
              end,
            }, function(choice)
              local result = results[choice]
              if result then
                vim.fn.setreg("+", result) -- 复制到系统剪贴板
                vim.notify("已复制: " .. result)
              end
            end)
          end,
        },
      },
    },
  },
}
