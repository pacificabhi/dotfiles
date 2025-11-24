return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format current buffer" })
    end,
    opts = function()
      local auto_format_filetypes = {
        go = true,
        proto = true,
      }

      return {
        notify_on_error = false,
        format_on_save = function(bufnr)
          if auto_format_filetypes[vim.bo[bufnr].filetype] then
            return { timeout_ms = 2000, lsp_fallback = true }
          end
        end,
        formatters_by_ft = {
          go = { "gofmt" },
          proto = { "clang_format" },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local severity = vim.diagnostic.severity
      local uv = vim.uv or vim.loop
      local lint_timers = {}

      local function set_status(bufnr, status)
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.b[bufnr].lint_status = status
        end
      end
      _G.NvimLintStatus = function()
        local bufnr = vim.api.nvim_get_current_buf()
        return vim.b[bufnr].lint_status or "Lint: idle"
      end

      local function is_linter_available(name)
        local linter = lint.linters[name]
        if not linter then
          return false
        end
        local cmd = linter.cmd or name
        if type(cmd) == "table" then
          cmd = cmd[1]
        end
        return type(cmd) == "string" and vim.fn.executable(cmd) == 1
      end

      local function cancel_timer(bufnr)
        if lint_timers[bufnr] then
          lint_timers[bufnr]:stop()
          lint_timers[bufnr]:close()
          lint_timers[bufnr] = nil
        end
      end

      local function summarize_diagnostics(bufnr, sources)
        local errs, warns = 0, 0
        local diag = vim.diagnostic.get(bufnr)
        for _, d in ipairs(diag) do
          if d.source and sources[d.source] then
            if d.severity == severity.ERROR then
              errs = errs + 1
            elseif d.severity == severity.WARN then
              warns = warns + 1
            end
          end
        end
        return errs, warns
      end

      local function lint_filetype(bufnr, ft)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        ft = ft or vim.bo[bufnr].filetype
        local configured = lint.linters_by_ft[ft]
        if not configured then
          set_status(bufnr, "Lint: not configured")
          return
        end
        local runnable = {}
        local missing = {}
        for _, name in ipairs(configured) do
          if is_linter_available(name) then
            table.insert(runnable, name)
          else
            table.insert(missing, name)
          end
        end
        if #runnable > 0 then
          set_status(bufnr, "Lint: running")
          vim.api.nvim_buf_call(bufnr, function()
            lint.try_lint(runnable)
          end)
          local source_lookup = {}
          for _, name in ipairs(runnable) do
            source_lookup[name] = true
          end
          vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            local errs, warns = summarize_diagnostics(bufnr, source_lookup)
            if errs > 0 then
              set_status(bufnr, string.format("Lint: %dE %dW", errs, warns))
            elseif warns > 0 then
              set_status(bufnr, string.format("Lint: %dW", warns))
            else
              set_status(bufnr, "Lint: clean")
            end
          end, 1000)
        else
          set_status(bufnr, string.format("Lint: missing %s", table.concat(missing, ", ")))
        end
      end
      local function debounce_lint(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not uv then
          lint_filetype(bufnr)
          return
        end
        cancel_timer(bufnr)
        local timer = uv.new_timer()
        lint_timers[bufnr] = timer
        timer:start(400, 0, function()
          vim.schedule(function()
            cancel_timer(bufnr)
            if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
              lint_filetype(bufnr)
            end
          end)
        end)
      end

      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.go = { "golangcilint" }
      lint.linters_by_ft.proto = { "buf" }

      vim.api.nvim_create_user_command("Lint", function()
        lint_filetype(vim.api.nvim_get_current_buf())
      end, { desc = "Run configured linters for the current buffer" })

      local lint_group = vim.api.nvim_create_augroup("AutoLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = lint_group,
        callback = function(args)
          lint_filetype(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = lint_group,
        callback = function(args)
          lint_filetype(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = lint_group,
        callback = function(args)
          debounce_lint(args.buf)
        end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = lint_group,
        callback = function(args)
          set_status(args.buf, "Lint: idle")
        end,
      })
      vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
        group = lint_group,
        callback = function(args)
          cancel_timer(args.buf)
        end,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "goimports",
          "golangci-lint",
          "buf",
          "clang-format",
        },
        auto_update = false,
        run_on_start = false,
      })
    end,
  },
}
