return {
  -- {
  --   'stevearc/oil.nvim',
  --   lazy = false,
  --   ---@module 'oil'
  --   ---@type oil.SetupOpts
  --   opts = {},
  --   use_default_keymaps = true,
  --   -- Optional dependencies
  --   dependencies = { { "echasnovski/mini.icons", opts = {} } },
  --   -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  --   config = function()
  --     vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  --   end
  -- }
  -- {
  --   'stevearc/oil.nvim',
  --   config = function()
  --     require('oil').setup({ keymaps = { ["<Esc>"] = "actions.close" } })
  --   end,
  --   keys = {
  --     { '<leader>e', '<cmd>Oil<cr>',         mode = 'n', desc = "Open Filesystem" },
  --     { '<leader>p', '<cmd>Oil --float<cr>', mode = 'n', desc = "Open Floating Filesystem" },
  --   }
  -- }
}
