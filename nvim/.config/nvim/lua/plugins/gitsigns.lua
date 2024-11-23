return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    local keymap = vim.keymap
    keymap.set("n", "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "toggle line blame" })
    keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview changes" })
  end,
}
