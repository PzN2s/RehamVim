local M = {}

local group = vim.api.nvim_create_augroup("reham_typewriter", { clear = true })

function M.toggle()
  local enabled = not vim.g.reham_typewriter
  vim.g.reham_typewriter = enabled
  vim.opt.scrolloff = enabled and 999 or 8
  vim.wo[0].relativenumber = not enabled
  if enabled then
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      callback = function()
        vim.cmd.normal("zz")
      end,
    })
    vim.cmd.normal("zz")
  else
    vim.api.nvim_clear_autocmds({ group = group })
  end
  vim.notify(enabled and "Typewriter: on" or "Typewriter: off", vim.log.levels.INFO)
end

return M