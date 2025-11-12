return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "gopls" },
    },
    config = function(_, opts)
      local mason_lsp = require("mason-lspconfig")

      local goimports_group = vim.api.nvim_create_augroup("GoAutoImports", {})
      local function go_organize_imports(bufnr, position_encoding)
        position_encoding = position_encoding or "utf-16"
        local params = vim.lsp.util.make_range_params(nil, position_encoding)
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
        if not result then
          return
        end

        for _, res in pairs(result) do
          for _, action in pairs(res.result or {}) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, position_encoding)
            elseif action.command then
              vim.lsp.buf.execute_command(action.command)
            end
          end
        end
      end

      local on_attach = function(client, bufnr)
        local map_opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, map_opts)

        if client and client.name == "gopls" then
          vim.api.nvim_clear_autocmds({ group = goimports_group, buffer = bufnr })
          local encoding = client.offset_encoding or "utf-16"
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = goimports_group,
            buffer = bufnr,
            callback = function()
              go_organize_imports(bufnr, encoding)
            end,
          })
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        gopls = {},
      }

      for server_name, server_opts in pairs(servers) do
        vim.lsp.config(server_name, vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, server_opts))
      end

      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or vim.tbl_keys(servers)
      mason_lsp.setup(opts)
    end,
  },
}
