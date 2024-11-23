return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local telescope = require("telescope")

    -- Harpoon setup
    require("harpoon").setup({
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

    -- Load Harpoon extension for Telescope
    telescope.load_extension("harpoon")

    -- Set keymaps
    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>ho",
      "<cmd>lua require('telescope').extensions.harpoon.marks()<cr>",
      { desc = "Open Harpoon menu in Telescope" }
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
  end,
}
