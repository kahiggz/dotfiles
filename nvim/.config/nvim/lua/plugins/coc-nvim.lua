return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false, -- Adjust this to true if you want it to load lazily
    config = function()
      -- Custom configuration for CoC
      -- vim.cmd([[
      --   " Use <tab> for trigger completion and navigate to the next item in completion menu
      --   inoremap <silent><expr> <TAB>
      --         \ coc#pum#visible() ? coc#pum#next(1) :
      --         \ CheckBackspace() ? "\<Tab>" :
      --         \ coc#refresh()
      --   inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      --
      --   function! CheckBackspace() abort
      --       let col = col('.') - 1
      --       return !col || getline('.')[col - 1]  =~# '\s'
      --   endfunction
      --
      --   " Make <CR> auto-select the first completion item and notify coc.nvim to format on enter
      --   inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
      -- ]])
    end,
  },
}
