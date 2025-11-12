return {
  {
    "vim-airline/vim-airline",
    priority = 1000,
    lazy = false,
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
    init = function()
      vim.opt.showtabline = 2
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_theme = "dracula"
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tabline#formatter"] = "unique_tail_improved"
      vim.g["airline#extensions#branch#enabled"] = 1
      vim.g["airline#extensions#lsp#enabled"] = 1
      vim.g["airline#extensions#lsp#error_symbol"] = "E:"
      vim.g["airline#extensions#lsp#warning_symbol"] = "W:"
    end,
  },
}
