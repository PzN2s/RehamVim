-- Breadcrumb winbar (file path + symbols), themed by the wal colorscheme via
-- the standard highlight groups the reham engine already defines
-- (WinBar, barbecue_*). Hidden where it adds noise.
return {
  {
    "Bekaboo/dropbar.nvim",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      bar = {
        enable = function(buf, win)
          local ft = vim.bo[buf].ft
          if
            vim.tbl_contains({
              "dashboard",
              "snacks_dashboard",
              "lazy",
              "mason",
              "NvimTree",
              "neo-tree",
              "Trouble",
              "trouble",
              "noice",
              "qf",
              "help",
            }, ft)
          then
            return false
          end
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
    },
  },
}
