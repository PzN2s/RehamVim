---@type LazySpec
-- NOTE: Go module — server, lint, and test adapter in one self-contained spec.

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              appends = true,
              asmdecl = true,
              assign = true,
              atomic = true,
              atomicalign = true,
              bools = true,
              buildtag = true,
              cgocall = true,
              composites = true,
              copylocks = true,
              deepequalerrors = true,
              defers = true,
              directive = true,
              errorsas = true,
              fieldalignment = true,
              httpresponse = true,
              ifaceassert = true,
              infertypeargs = true,
              loopclosure = true,
              lostcancel = true,
              nilfunc = true,
              nilness = true,
              printf = true,
              shift = true,
              sigchanyzer = true,
              sortslice = true,
              stdmethods = true,
              stringintconv = true,
              structtag = true,
              testinggoroutine = true,
              tests = true,
              timeformat = true,
              unmarshal = true,
              unreachable = true,
              unsafeptr = true,
              unusedparams = true,
              unusedresult = true,
              unusedvariable = true,
              useany = true,
            },

            shadow = false,
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = {
          "golangcilint",
        },
      },

      linters = {
        golangcilint = {
          cmd = "golangci-lint",
          stdin = true,
          append_fname = true,
          args = {
            "run",
            "--output.json.path=stdout",
            "--show-stats=false",
            "--issues-exit-code=0",
            "--path-mode=abs",
          },
          stream = "stdout",
          ignore_exitcode = true,
          parser = function(output)
            local ok, decoded = pcall(vim.json.decode, output)

            if not ok or not decoded or not decoded.Issues then
              return {}
            end

            local diagnostics = {}

            for _, issue in ipairs(decoded.Issues) do
              local severity = vim.diagnostic.severity.WARN

              if issue.Severity == "error" then
                severity = vim.diagnostic.severity.ERROR
              elseif issue.Severity == "info" then
                severity = vim.diagnostic.severity.INFO
              end

              table.insert(diagnostics, {
                lnum = (issue.Pos and issue.Pos.Line or 1) - 1,
                col = (issue.Pos and issue.Pos.Column or 1) - 1,
                message = issue.Text or issue.FromLinter or "golangci-lint issue",
                severity = severity,
                source = issue.FromLinter or "golangci-lint",
              })
            end

            return diagnostics
          end,
        },
      },
    },
  },
  "fredrikaverpil/neotest-golang",
}