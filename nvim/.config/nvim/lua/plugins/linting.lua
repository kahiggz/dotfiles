return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Specify linters for Angular and TypeScript files
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" }, -- Angular component files (e.g., .ts, .html)
      html = { "eslint" }, -- To lint Angular HTML templates
      -- Additional linters can be added as needed
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
