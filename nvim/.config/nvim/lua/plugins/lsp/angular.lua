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
        "typescript-language-server",
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
      -- Disable preview window in completion
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      
      -- Override default definition handler to prevent preview window
      vim.lsp.handlers["textDocument/definition"] = function(_, result)
        if not result or vim.tbl_isempty(result) then
          return nil
        end
        
        if vim.tbl_islist(result) then
          -- Multiple results, use first one
          local uri = result[1].uri or result[1].targetUri
          local range = result[1].range or result[1].targetSelectionRange
          
          local target_filename = vim.uri_to_fname(uri)
          vim.cmd("edit " .. vim.fn.fnameescape(target_filename))
          vim.api.nvim_win_set_cursor(0, {
            range.start.line + 1,
            range.start.character
          })
        else
          -- Single result
          local uri = result.uri or result.targetUri
          local range = result.range or result.targetSelectionRange
          
          local target_filename = vim.uri_to_fname(uri)
          vim.cmd("edit " .. vim.fn.fnameescape(target_filename))
          vim.api.nvim_win_set_cursor(0, {
            range.start.line + 1,
            range.start.character
          })
        end
      end
      
      -- Use standard capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      local lspconfig = require("lspconfig")

      -- Setup the servers directly
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

      lspconfig.angularls.setup({
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        filetypes = { "css", "scss", "less" },
      })

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
