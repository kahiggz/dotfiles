return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Harpoon setup
    require("harpoon").setup({
      -- To see more options, visit :help harpoon
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
        mark_branch = true,
        tabline = false,
        tabline_prefix = "   ",
        tabline_suffix = "   ",
      },
    })

    -- Set keymaps for Harpoon actions
    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>ho",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Open Harpoon menu" }
    )
    keymap.set(
      "n",
      "<leader>hm",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { desc = "Mark file with Harpoon" }
    )
    keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Go to next Harpoon mark" })
    keymap.set(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      { desc = "Go to previous Harpoon mark" }
    )
    keymap.set(
      "n",
      "<leader>hr",
      "<cmd>lua require('harpoon.mark').rm_file()<cr>",
      { desc = "Remove current file from Harpoon" }
    )
  end,
}
