local Lsp = require("utils.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "yioneko/nvim-vtsls",
      },
      -- Typescript formatter
      {
        "dmmulroy/ts-error-translator.nvim",
        ft = "javascript,typescript,typescriptreact,svelte",
        opts = {
          auto_override_publish_diagnostics = true,
        },
      },
    },
    opts = {
      servers = {
        -- ---@type lspconfig.options.vtsls
        vtsls = {
          -- add keymap
          keys = {
            {
              "<leader>cV",
              "<cmd>VtsExec select_ts_version<cr>",
              desc = "Select TS workspace version",
            },
          },

          -- Settings
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              updateImportsOnFileMove = {
                enabled = "always",
              },
            },
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              updateImportsOnFileMove = {
                enabled = "always",
              },
            },
          },
        },
      },
      setup = {
        -- Disable tsserver
        tsserver = function()
          return true
        end,
        vtsls = function()
          -- Disable tsserver if denols is present
          if Lsp.deno_config_exist() then
            return true
          end
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
    end,
  },
}
