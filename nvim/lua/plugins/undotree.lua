return {
  "mbbill/undotree",
  config = function()
    -- Configuration
    vim.g.undotree_WindowLayout = 2       -- Layout style
    vim.g.undotree_ShortIndicators = 1     -- Use short time indicators
    vim.g.undotree_SetFocusWhenToggle = 1  -- Focus undotree on toggle

    -- Keymap to toggle undotree
    vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle" })
  end,
}
