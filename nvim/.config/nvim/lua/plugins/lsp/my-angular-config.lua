return {
  -- Mason setup for managing LSP servers, DAP servers, linters, and formatters
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Bridge between mason and lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      -- Automatically install these servers
      ensure_installed = {
        "lua_ls",    -- Lua language server
        "angularls", -- Angular language server
        "ts_ls",     -- TypeScript language server (replaces tsserver)
        "cssls",     -- CSS language server
        "html",      -- HTML language server
        "eslint",    -- ESLint language server
        "jsonls",    -- JSON language server
        -- "emmet_ls", -- Emmet for HTML/CSS
      },
      -- Automatically enable installed servers
      automatic_installation = true,
    },
  },

  -- Additional tool installer for formatters, linters, etc.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",   -- Lua formatter
        "prettier", -- Multi-language formatter
        "eslint_d", -- Fast ESLint daemon
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- Get completion capabilities
      local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Improved diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Configure diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Enhanced LSP handlers
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- Custom on_attach function for keymaps and options
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Set keymaps (fallback to built-in LSP if Telescope not available)
        local telescope_ok = pcall(require, "telescope.builtin")

        if telescope_ok then
          vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
          vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        else
          vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, opts)
        end

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

        -- Format on save for specific filetypes
        if client.supports_method("textDocument/formatting") then
          local format_group = vim.api.nvim_create_augroup("LspFormat", { clear = false })
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = format_group,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- Server configurations
      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              -- Make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
              workspace = {
                -- Make language server aware of runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        },

        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        angularls = {
          root_dir = lspconfig.util.root_pattern("angular.json", "project.json", "nx.json"),
        },

        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },

        html = {
          filetypes = { "html", "templ" },
        },

        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },

        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },

        -- emmet_ls = {
        --   filetypes = {
        --     "html",
        --     "htmldjango",
        --     "css",
        --     "sass",
        --     "scss",
        --     "less",
        --     "javascript",
        --     "typescript",
        --     "javascriptreact",
        --     "typescriptreact",
        --     "vue",
        --     "svelte",
        --   },
        -- },
      }

      -- Setup each server individually
      local servers_to_setup = {
        "lua_ls",
        "ts_ls",
        "angularls",
        "cssls",
        "html",
        "jsonls",
        "eslint",
        -- "emmet_ls",
      }

      for _, server_name in ipairs(servers_to_setup) do
        local server_config = server_configs[server_name] or {}
        server_config.capabilities = capabilities
        server_config.on_attach = on_attach

        lspconfig[server_name].setup(server_config)
      end

      -- Set up LspAttach autocommand for additional functionality
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
    end,
  },

  -- Enhanced schema support for JSON files (optional)
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
    config = function()
      -- This will be used by jsonls if available
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")

      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
}
