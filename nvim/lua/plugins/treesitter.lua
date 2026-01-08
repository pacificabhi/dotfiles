return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local treeconfig = require("nvim-treesitter.configs")
    treeconfig.setup({
      ensure_installed = {"lua", "javascript", "go", "json", "jsonnet"},
      highlight = {enable = true},
      indent = {enable = true},
    })
  end
}
