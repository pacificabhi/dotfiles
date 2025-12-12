return {
  "folke/noice.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- Override markdown rendering so that cmp and other plugins use Treesitter
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- Presets for easier configuration
      presets = {
        bottom_search = true,        -- Use floating window for search (centered)
        command_palette = false,       -- Position cmdline and popupmenu together
        long_message_to_split = true, -- Long messages to split
        inc_rename = false,           -- Enable input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- Add border to hover docs and signature help
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>nl", ":Noice last<CR>", { desc = "Noice: Last message" })
    vim.keymap.set("n", "<leader>nh", ":Noice history<CR>", { desc = "Noice: History" })
    vim.keymap.set("n", "<leader>nd", ":Noice dismiss<CR>", { desc = "Noice: Dismiss all" })
  end,
}
