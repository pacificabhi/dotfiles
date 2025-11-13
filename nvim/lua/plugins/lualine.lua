return {
  {
    "nvim-lualine/lualine.nvim",
    priority = 500,
    config = function()
      local function lint_status()
        if _G.NvimLintStatus then
          return _G.NvimLintStatus()
        end
        return ""
      end

      require('lualine').setup({
        options = {
          theme = 'dracula'
        },
        sections = {
          lualine_c = {
            { 'filename', path = 1 },
          },
          lualine_x = {
            lint_status,
            'encoding',
            'fileformat',
            'filetype',
          },
        },
      })
    end,
  },
}
