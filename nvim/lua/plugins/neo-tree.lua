return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  keys = {
    { "<leader>e", ":Neotree toggle filesystem reveal left<CR>", desc = "Toggle Neo-tree" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
          ["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
          ["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
        },
      },
    },
  },
}

