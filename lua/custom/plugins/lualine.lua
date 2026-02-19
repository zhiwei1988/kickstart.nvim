return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'letieu/harpoon-lualine',
  },
  config = function()
    local harpoon = require 'harpoon'

    local function make_harpoon_component(index)
      return {
        function()
          local list = harpoon:list()
          local item = list.items[index]
          if not item then
            return ''
          end
          return index .. ' ' .. vim.fn.fnamemodify(item.value, ':t')
        end,
        color = function()
          local current = vim.fn.expand '%:.'
          local list = harpoon:list()
          local item = list.items[index]
          if item and item.value == current then
            return { fg = '#fe640b' }
          end
          return nil
        end,
        on_click = function(clicks, button)
          if clicks >= 2 and button == 'l' then
            harpoon:list():select(index)
          end
        end,
      }
    end

    require('lualine').setup {
      options = {
        theme = 'auto',
      },
      tabline = {
        lualine_a = (function()
          local max_slots = 10
          local components = {}
          for i = 1, max_slots do
            components[i] = make_harpoon_component(i)
          end
          return components
        end)(),
      },
    }
  end,
}
