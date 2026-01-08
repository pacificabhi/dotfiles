return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume search" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            preview_height = 0.6,    -- 60% height for preview (top)
            preview_cutoff = 0,      -- Always show preview
            width = 0.9,             -- 90% of screen width
            height = 0.9,            -- 90% of screen height
            mirror = false,          -- Preview on top, results on bottom
          },
        },
      },
    })
  end,
}
