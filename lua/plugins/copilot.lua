return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   opts = {
  --     panel = {
  --       enabled = true,
  --       auto_refresh = false,
  --       keymap = {
  --         jump_prev = "[[",
  --         jump_next = "]]",
  --         accept = "<CR>",
  --         refresh = "gr",
  --         open = "<M-CR>",
  --       },
  --       layout = {
  --         position = "top", -- | top | left | right
  --         ratio = 0.4,
  --       },
  --     },
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = false,
  --       debounce = 75,
  --       keymap = {
  --         accept = "<C-i>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<C-j>",
  --         prev = "<C-k>",
  --         dismiss = "<C-q>",
  --       },
  --     },
  --     copilot_node_command = "node", -- Node.js version must be > 18.x
  --     server_opts_overrides = {},
  --   },
  -- },
  -- Disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    keys = function()
      return {}
    end,
  },
  -- Setup nvim-cmp
  {
    "nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- Disable ghost text for nvim-cmp, use copilot suggestion instead
      opts.experimental.ghost_text = false
    end,
  },
  -- Setup copilot.vim
  {
    "github/copilot.vim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      -- For copilot.vim
      -- enable copilot for specific filetypes
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
      }

      -- Set to true to assume that copilot is already mapped
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_workspace_folders = "~/"

      -- Setup keymaps
      local keymap = vim.keymap.set
      local opts = { silent = true }

      -- Set <C-i> to accept line
      keymap("i", "<C-i>", "<Plug>(copilot-accept-line)", opts)

      -- Set <C-j> to next suggestion, <C-k> to previous suggestion, <C-l> to suggest
      keymap("i", "<C-]>", "<Plug>(copilot-next)", opts)
      keymap("i", "<C-[>", "<Plug>(copilot-previous)", opts)
      keymap("i", "<C-l>", "<Plug>(copilot-suggest)", opts)

      -- Set <C-d> to dismiss suggestion
      keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
    end,
  },
  -- Add status line icon for copilot
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("lazyvim.config").icons.kinds.Copilot
          return icon
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          return Util.ui.fg("Special")
        end,
      })
    end,
  },
}
