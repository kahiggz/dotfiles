return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        layout_strategy = "flex", -- Retain the flexible layout
        layout_config = {
          width = 0.80,
          height = 0.80,
          prompt_position = "bottom", -- Set the prompt at the bottom
          preview_cutoff = 120,
          horizontal = { mirror = false },
          vertical = { mirror = false },
        },
        path_display = function(opts, path)
          local tail = require("telescope.utils").path_tail(path)
          return string.format("%s (%s)", tail, path) -- Display filename and path
        end,
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- Move to the previous result
            ["<C-j>"] = actions.move_selection_next, -- Move to the next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Add to quickfix list
          },
        },
      },
    })

    -- Load the fzf extension
    telescope.load_extension("fzf")

    -- Key mappings for launching Telescope commands
    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "List marks" })
  end,
}
