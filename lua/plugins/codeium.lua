-- NOTE: Only enable either copilot-vim or codeium-vim at the same time
return {
  -- Disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    keys = function()
      return {}
    end,
  },
  -- Add codeium, make sure that you ran :Codeium Auth after installation.
  {
    "Exafunction/codeium.vim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    version = "1.8.37",
    config = function()
      -- require("codeium").setup({
      --   enable_chat = true
      --   })

      -- Disable files that you don't want to use codeium
      vim.g.codeium_filetypes = {
        ["TelescopePrompt"] = false,
      }

      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true })
      vim.keymap.set("i", "<C-j>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true })
      vim.keymap.set("i", "<C-k>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true })
      vim.keymap.set("i", "<C-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true })
      vim.keymap.set("i", "<C-i>", function()
        return vim.fn["codeium#Complete"]()
      end, { expr = true })
      vim.keymap.set("i", "<C-c>", function()
        return vim.fn["codeium#Chat"]()
      end, { expr = true })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local icon = require("lazyvim.config").icons.kinds.Codeium
      local function show_codeium_status()
        return icon .. vim.fn["codeium#GetStatusString"]()
      end

      -- Insert the icon
      table.insert(opts.sections.lualine_x, 2, show_codeium_status)
    end,
  },
}
