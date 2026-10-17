-- NixOS-safe binary resolution.
--
-- mason's binaries are dynamically linked for generic Linux and fail to start
-- on NixOS (stub-ld), and mason's bin directory shadows $PATH, so a bare
-- command name can resolve to a broken copy. Prefer the binary from the user's
-- Nix profile when it exists — `~` is expanded here, never by a shell, so the
-- config stays portable across usernames and machines — and fall back to the
-- plain name so it still works with distro packages or a global install.
local M = {}

function M.bin(name)
  local path = vim.fn.expand("~/.nix-profile/bin/" .. name)
  if vim.fn.executable(path) == 1 then
    return path
  end
  return name
end

return M
