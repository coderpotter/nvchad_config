---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>gg"] = {":LazyGit<CR>", "lazygit"},
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- more keybinds!

return M
