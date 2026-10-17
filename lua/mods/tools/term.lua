local toolbin = require("lib.toolpath").bin

return {
  {
    -- marksman runs from the Nix profile (boot/lsp_extra.lua pins the command):
    -- mason's copy is dynamically linked and cannot start on NixOS, so keep
    -- mason-lspconfig from installing or auto-enabling a second, broken one.
    "neovim/nvim-lspconfig",
    opts = { servers = { marksman = { mason = false } } },
  },
  {
    "folke/snacks.nvim",
    enabled = true,
    opts = {
      picker = { enabled = true },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      persist_mode = true,
      shade_terminals = false,
    },

    keys = {
      { "<leader>td", false },

      {
        "<leader>t",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "float",
              display_name = "Float",
            })
            :open()
        end,
        desc = "Terminal (Float)",
      },
      {
        "<leader>t.",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "float",
              display_name = "File Dir",
              dir = vim.fn.expand("%:p:h"),
            })
            :open()
        end,
        desc = "Terminal in File Dir",
      },
      -- New terminals
      {
        "<leader>th",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "horizontal",
              display_name = "Horizontal",
            })
            :open()
        end,
        desc = "New Horizontal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm.terminal").Terminal
            :new({
              direction = "vertical",
              display_name = "Vertical",
            })
            :open()
        end,
        desc = "New Vertical",
      },

      -- Toggle
      {
        "<leader>tH",
        "<cmd>ToggleTerm direction=horizontal<CR>",
        desc = "Toggle Horizontal",
      },
      {
        "<leader>tV",
        "<cmd>ToggleTerm direction=vertical<CR>",
        desc = "Toggle Vertical",
      },

      -- Instance picker
      {
        "<leader>tt",
        "<cmd>TermSelect<CR>",
        desc = "Terminal List",
      },

      -- Kill focused
      {
        "<leader>tk",
        function()
          local ok, Terminal = pcall(require, "toggleterm.terminal")
          if not ok then
            return
          end

          local id = vim.b.toggle_number
          if not id then
            vim.notify("Not inside a ToggleTerm", vim.log.levels.WARN)
            return
          end

          local term = Terminal.get(id)
          if term then
            term:shutdown()
          end
        end,
        desc = "Kill Terminal",
      },
    },

    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Double Esc -> Normal mode
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
        desc = "Terminal Normal Mode",
        silent = true,
      })
    end,
  },
  -- NOTE: extra dev plugins live here (not in new spec files) because this
  -- file is proven to be picked up by lazy.nvim's importer.
  {
    -- Highlight + search TODO/FIXME/NOTE comments.
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo List" },
    },
    opts = {},
  },
  {
    -- Edit directories like buffers (file manager inside nvim).
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory" },
    },
    opts = {
      default_file_explorer = false,
    },
  },
  {
    -- Pin files and jump between them instantly.
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>hm",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon Menu",
      },
      {
        "<leader>hn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon Next",
      },
      {
        "<leader>hp",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon Prev",
      },
    },
    opts = {},
  },
  {
    -- Visual undo history tree.
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      -- NOTE: plain <leader>u stays the built-in "ui" toggles group;
      -- Undotree lives on capital U so it never shadows it.
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
  },
  {
    -- Highlight other uses of the word under cursor (+ jump with ]]/[[).
    -- NOTE: entry point is configure(), not setup().
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      delay = 100,
      large_file_cutoff = 2000,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
  -- More dev tools (proven file for lazy specs).
  {
    -- Auto-detect buffer indent (tabs vs spaces) per file.
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    -- Split/join code blocks (arrays, args, structs) with treesitter.
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Split/Join Block" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    -- Generate docstrings (function/class docs) for code.
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>nf",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Docstring",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },
  {
    -- Snippet engine (also lights up friendly-snippets + neogen + blink).
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = { history = true, delete_check_events = "TextChanged" },
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- More dev tools, batch 2.
  {
    -- Editable quickfix list (buffers you can :w to apply changes).
    "stevearc/quicker.nvim",
    ft = "qf",
    keys = {
      {
        "<leader>qo",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle Quickfix",
      },
    },
    opts = {},
  },
  {
    -- Convert identifier case (camel/snake/upper...) with live preview.
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>cc", "<cmd>TextCaseOpenTelescope<cr>", desc = "Change Case" },
    },
    opts = {},
  },
  {
    -- Formatter wiring LazyVim extras leave out (mirrors their own pattern).
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        nix = { "nixfmt" },
      },
      -- Pin NixOS-native binaries: mason's copies are dynamically linked
      -- for generic Linux and fail here with stub-ld, and mason's bin dir
      -- shadows PATH so bare names resolve to the broken ones.
      -- `toolbin` prefers ~/.nix-profile/bin and falls back to PATH.
      formatters = {
        stylua = { command = toolbin("stylua") },
        shfmt = { command = toolbin("shfmt") },
        gofumpt = { command = toolbin("gofumpt") },
        goimports = { command = toolbin("goimports") },
        prettier = { command = toolbin("prettier") },
        prettierd = { command = toolbin("prettierd") },
        ruff_format = { command = toolbin("ruff") },
        ["markdownlint-cli2"] = { command = toolbin("markdownlint-cli2") },
        ["markdown-toc"] = { command = toolbin("markdown-toc") },
      },
    },
  },
  {
    -- GitHub PR review inside nvim (needs `gh`, already installed).
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    -- Spell-check docs and text (codespell, installed via nix).
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "codespell" },
        text = { "codespell" },
      },
    },
  },
  -- More dev tools, batch 3: tiny classics, zero deps.
  {
    -- mini.files stays off: nvim-tree is the tree and oil.nvim opens
    -- parents on "-". (The boot/extras.lua import line is already
    -- commented out; this guarantees it regardless of import staleness.)
    "nvim-mini/mini.files",
    enabled = false,
  },
  {
    -- Scrollbar with diagnostics/git marks in the gutter.
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    -- Unix helpers: :Rename :Delete :Chmod :SudoWrite :Mkdir.
    "tpope/vim-eunuch",
    cmd = { "Rename", "Delete", "Chmod", "SudoWrite", "Mkdir", "Remove", "Move" },
  },
  {
    -- Paired navigation: [q/]q quickfix, [e/]e exchange lines, [space/]space blank lines and more.
    "tpope/vim-unimpaired",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    -- ASCII diagrams/boxes in docs (visual select, then draw).
    "jbyuki/venn.nvim",
    cmd = "VBox",
    keys = {
      { "<leader>vb", ":VBox<cr>", mode = "x", desc = "Draw Box" },
    },
  },
  -- Tiny toggles, all off unless explicitly enabled.
  {
    -- Rainbow CSV columns for data files.
    "mechatroner/rainbow_csv",
    ft = { "csv" },
  },
  {
    -- Vim-motion trainer overlay (off by default; :Precognition toggle).
    "tris203/precognition.nvim",
    cmd = { "Precognition" },
    opts = { startVisible = false },
  },
  {
    -- hjkl discipline coach (off by default; :Hardtime toggle).
    "m4xshen/hardtime.nvim",
    cmd = { "Hardtime" },
    config = function()
      require("hardtime").setup()
    end,
  },
  {
    -- Searchable undo history (visual diff of every change).
    -- (Projects already covered: LazyVim wires <leader>fp itself.)
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    config = function(_, opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    -- Marks in the sign column (no keymaps touched).
    "chentoast/marks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = { default_mappings = false },
  },
  {
    -- Align text (gaip= aligns a paragraph on =).
    "nvim-mini/mini.align",
    keys = {
      { "ga", mode = { "n", "x" } },
      { "gA", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    -- Text operators: evaluate (g=), replace (gr), sort (gs), multiply (gm).
    -- (gx stays netrw's open-URL.)
    "nvim-mini/mini.operators",
    keys = {
      { "g=", mode = { "n", "x" } },
      { "gr", mode = { "n", "x" } },
      { "gs", mode = { "n", "x" } },
      { "gm", mode = { "n", "x" } },
    },
    opts = {
      evaluate = { prefix = "g=" },
      exchange = { prefix = "gX" },
      multiply = { prefix = "gm" },
      replace = { prefix = "gr" },
      sort = { prefix = "gs" },
    },
  },
  {
    -- Trailing-whitespace highlight (shows, never auto-deletes).
    "nvim-mini/mini.trailspace",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    -- Git worktrees: parallel branches checked out side by side.
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>gW",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Worktrees",
      },
    },
    config = function(_, opts)
      require("telescope").load_extension("git_worktree")
    end,
  },
  {
    -- LSP progress eye-candy (indexing status that noice doesn't show).
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    -- Floating previews (definition/references/implementation in a popup).
    "rmagatti/goto-preview",
    keys = {
      { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview References" },
      { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview Implementation" },
    },
    opts = {},
  },
}
