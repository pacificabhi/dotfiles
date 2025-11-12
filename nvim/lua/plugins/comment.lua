return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Toggle line comment" },
      { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
      { "<C-_>", mode = { "n", "v" }, desc = "Toggle comment (VSCode style)" },
      { "<C-/>", mode = { "n", "v" }, desc = "Toggle comment (VSCode style)" },
      { "<C-S-_>", mode = "n", desc = "Toggle block comment (VSCode style)" },
      { "<C-S-/>", mode = "n", desc = "Toggle block comment (VSCode style)" },
    },
    config = function()
      require("Comment").setup({
        toggler = {
          line = "gc",
          block = "gb",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        mappings = {
          basic = true,
          extra = false,
        },
      })

      local api = require("Comment.api")
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

      local function toggle_line_comment()
        api.toggle.linewise.current()
      end
      local function toggle_block_comment()
        api.toggle.blockwise.current()
      end
      local function toggle_visual()
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end

      vim.keymap.set("n", "<C-_>", toggle_line_comment, { desc = "Toggle line comment (VSCode style)" })
      vim.keymap.set("n", "<C-/>", toggle_line_comment, { desc = "Toggle line comment (VSCode style)" })
      vim.keymap.set("n", "<C-S-_>", toggle_block_comment, { desc = "Toggle block comment (VSCode style)" })
      vim.keymap.set("n", "<C-S-/>", toggle_block_comment, { desc = "Toggle block comment (VSCode style)" })

      vim.keymap.set("x", "<C-_>", toggle_visual, { desc = "Toggle comment for selection (VSCode style)" })
      vim.keymap.set("x", "<C-/>", toggle_visual, { desc = "Toggle comment for selection (VSCode style)" })
    end,
  },
}
