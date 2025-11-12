return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    treeconfig = require("nvim-treesitter.configs")
    treeconfig.setup({
      ensure_installed = {"lua", "javascript", "go"},
      highlight = {enable = true},
      indent = {enable = true},
    })
  end
}
