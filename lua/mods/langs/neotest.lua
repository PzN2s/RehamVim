return {
  "nvim-neotest/neotest",
  keys = {
    { "<leader>t", false },
    { "<leader>td", false },
    { "<leader>tD", false },
    { "<leader>ta", false },
    { "<leader>tl", false },
    { "<leader>to", false },
    { "<leader>tO", false },
    { "<leader>tr", false },
    { "<leader>ts", false },
    { "<leader>tS", false },
    { "<leader>tt", false },
    { "<leader>tT", false },
    { "<leader>tw", false },

    { "<leader>T", desc = "+test" },
    {
      "<leader>Ta",
      function()
        require("neotest").run.attach()
      end,
      desc = "Attach to Test",
    },
    {
      "<leader>Tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>TT",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>Tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>Tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>Ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>To",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>TO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>TS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },
    {
      "<leader>Tw",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Toggle Watch",
    },
    {
      "<leader>Td",
      function()
        ---@diagnostic disable-next-line: missing-fields
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug Nearest",
    },
  },
}
