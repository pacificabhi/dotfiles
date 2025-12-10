return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
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

    local telescope_builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fr", telescope_builtin.resume, {})  -- Resume last search
  end,
}
