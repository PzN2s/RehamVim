return {
  { import = "lazyvim.plugins.extras.coding.blink" },
  { import = "lazyvim.plugins.extras.coding.yanky", keys = { "<leader>p", "<leader>y" } },
  { import = "lazyvim.plugins.extras.editor.dial" },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
  -- mini-diff disabled: it disabled gitsigns and drew its own signs next to the
  -- gitsigns ones (two sign groups in the same column). gitsigns is the one we
  -- want (blame + hunk keys), so the extra stays off. See mods/view/gitsigns.lua.
  -- { import = "lazyvim.plugins.extras.editor.mini-diff" },
  -- mini-files removed (was redundant): nvim-tree is the main tree and
  -- oil.nvim opens parent dirs on "-".
  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.editor.refactoring" },
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.ui.mini-animate" },
  { import = "lazyvim.plugins.extras.ui.smear-cursor" },
  -- treesitter-context disabled: sticky header bar removed per user request.
  -- { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "lazyvim.plugins.extras.util.dot" },
  { import = "lazyvim.plugins.extras.util.gh" },
  { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
  { import = "lazyvim.plugins.extras.util.project" },
  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.kotlin" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.nushell" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.vue" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
}
