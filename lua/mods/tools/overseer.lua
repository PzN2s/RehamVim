-- Task runner (build/test/lint tasks with output parsing).
return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerRun",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
    },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build task" },
      { "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "Task action" },
    },
    opts = {
      task_list = { direction = "bottom", min_height = 12 },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
      local overseer = require("overseer")
      -- One-shot build/test tasks per language (<leader>or to pick).
      overseer.register_template({
        name = "go build ./...",
        builder = function()
          return { cmd = { "go", "build", "./..." } }
        end,
        condition = { filetype = { "go" } },
      })
      overseer.register_template({
        name = "go test ./...",
        builder = function()
          return { cmd = { "go", "test", "./..." } }
        end,
        condition = { filetype = { "go" } },
      })
      overseer.register_template({
        name = "cargo test",
        builder = function()
          return { cmd = { "cargo", "test" } }
        end,
        condition = { filetype = { "rust" } },
      })
      overseer.register_template({
        name = "cargo run",
        builder = function()
          return { cmd = { "cargo", "run" } }
        end,
        condition = { filetype = { "rust" } },
      })
      overseer.register_template({
        name = "cargo build",
        builder = function()
          return { cmd = { "cargo", "build" } }
        end,
        condition = { filetype = { "rust" } },
      })
      overseer.register_template({
        name = "npm test",
        builder = function()
          return { cmd = { "npm", "test", "--", "--watchAll=false" } }
        end,
        condition = { filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
      })
      overseer.register_template({
        name = "npm run build",
        builder = function()
          return { cmd = { "npm", "run", "build" } }
        end,
        condition = { filetype = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
      })
      overseer.register_template({
        name = "pytest file",
        builder = function()
          return { cmd = { "pytest", vim.fn.expand("%") } }
        end,
        condition = { filetype = { "python" } },
      })
      overseer.register_template({
        name = "make",
        builder = function()
          return { cmd = { "make" } }
        end,
        condition = { filetype = { "c", "cpp", "make" } },
      })
    end,
  },
}
