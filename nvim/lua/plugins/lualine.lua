return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local function jumplist_status()
      local jumps, current_pos = unpack(vim.fn.getjumplist())
      local bufs = {}

      -- Use a map to keep track of buffer numbers and their positions in the `bufs` table
      local buf_map = {}

      -- Iterate up to the current position in the jumplist
      for i = 1, current_pos + 1 do
        if jumps[i] then
          local bufnr = jumps[i].bufnr
          if bufnr and bufnr ~= 0 then
            if buf_map[bufnr] then
              -- If we've seen this buffer before, truncate the list
              local pos = buf_map[bufnr]
              for j = #bufs, pos + 1, -1 do
                buf_map[bufs[j]] = nil
                table.remove(bufs, j)
              end
            else
              -- Otherwise, add it to our list
              table.insert(bufs, bufnr)
              buf_map[bufnr] = #bufs
            end
          end
        end
      end

      if #bufs == 0 then
        return ""
      end

      local file_names = {}
      for i = 1, #bufs do
        file_names[i] = vim.fn.fnamemodify(vim.fn.bufname(bufs[i]), ":t")
      end

      local journey = table.concat(file_names, " > ")
      -- Limit the length of the journey string to avoid overflowing the statusline
      if #journey > 50 then
        journey = "..." .. string.sub(journey, #journey - 49, #journey)
      end
      return journey
    end

    require('lualine').setup({
      options = {
        theme = 'dracula'
      },
      sections = {
        lualine_c = {
          { jumplist_status },
          { 'filename', path = 1 },
        },
      },
    })
  end
}
