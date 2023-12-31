---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>gg"] = {":LazyGit<CR>", "lazygit"},
    ["Q"] = {":q<CR>", "Quit"},
    ["<localleader>w"] = {":w<CR>", "Save"},
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- more keybinds!

return M
