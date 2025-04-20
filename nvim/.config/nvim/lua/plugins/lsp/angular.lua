return {
  -- Mason setup
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {

      ensure_installed = {
        "lua-language-server",
        "stylua",
        "angular-language-server",
        "typescript-language-server", -- ✅ correct tool name for Mason
        "css-lsp",
        "html-lsp",
        "eslint-lsp",
        "prettier",
      },
    },
    config = true,
  },

  -- Mason-lspconfig setup
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = true,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup LSP servers
      require("mason-lspconfig").setup_handlers({
        -- Default handler for all servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Lua-specific configuration
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,

        -- Angular-specific configuration
        ["angularls"] = function()
          lspconfig.angularls.setup({
            capabilities = capabilities,
            root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
          })
        end,

        -- TypeScript configuration

        ["ts_ls"] = function()
          lspconfig.tsserver.setup({
            capabilities = capabilities,
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
          })
        end,

        -- CSS configuration
        ["cssls"] = function()
          lspconfig.cssls.setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
          })
        end,

        -- ESLint configuration
        ["eslint"] = function()
          lspconfig.eslint.setup({
            capabilities = capabilities,
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
              "html",
            },
            settings = {
              codeAction = {
                disableRuleComment = {
                  enable = true,
                  location = "separateLine",
                },
                showDocumentation = {
                  enable = true,
                },
              },
              format = true,
              onIgnoredFiles = "off",
              problems = {
                shortenToSingleLine = false,
              },
              run = "onType",
              validate = "on",
            },
          })
        end,
      })

      -- Setup key mappings for LSP functions
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          -- Additional useful mappings
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}
