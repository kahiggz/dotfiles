return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "json",
          "javascript",
          "typescript",
          "yaml",
          "html",
          "css",
          "vim",
          "dockerfile",
          "gitignore",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
