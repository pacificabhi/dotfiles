return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text = true,
        virt_text_pos = "eol",
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
      signcolumn = true,
      update_debounce = 200,
      preview_config = {
        border = "rounded",
        style = "minimal",
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "]g", gitsigns.next_hunk, "Next git hunk")
        map("n", "[g", gitsigns.prev_hunk, "Previous git hunk")
        map({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, "Stage git hunk")
        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo staged hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset git hunk")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Preview inline hunk")
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line (full)")
        map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff against index")
        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, "Diff against HEAD")
        map("n", "<leader>gt", gitsigns.toggle_deleted, "Toggle deleted lines")
      end,
    },
  },
}
