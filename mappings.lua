---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>gg"] = { ":LazyGit<CR>", "lazygit" },
    ["Q"] = { ":q<CR>", "Quit" },
    ["<leader>fs"] = { ":call CocActionAsync('codeAction', 'cursor')<CR>", "Sourcery Suggestion" },
    ["<leader>fS"] = { ":CocDiagnostics", "All Sourcery Suggestions" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
