return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Toggle line comment" },
      { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
      { "<leader>/", mode = { "n", "v" }, desc = "Toggle comment (leader)" },
      { "<leader>cb", mode = "n", desc = "Toggle block comment (leader)" },
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

      vim.keymap.set("n", "<leader>/", toggle_line_comment, { desc = "Toggle line comment" })
      vim.keymap.set("n", "<leader>cb", toggle_block_comment, { desc = "Toggle block comment" })

      vim.keymap.set("x", "<leader>/", toggle_visual, { desc = "Toggle comment for selection" })
    end,
  },
}
