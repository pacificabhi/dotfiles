return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,  -- Better syntax highlighting in diffs
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>", { desc = "Diffview: Open" })
    vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Diffview: Close" })
    vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "Diffview: File history" })
    vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory %<CR>", { desc = "Diffview: Current file history" })
    vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "Diffview: Refresh" })
  end,
}
