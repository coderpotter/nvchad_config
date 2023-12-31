# Instructions

1. Install neovim
2. Clone the repo inside `.config/nvim/lua/` by running
   `gh repo clone coderpotter/nvchad_config && mv nvchad_config/ custom/`
3. Install the following:
   - [ ] LazyGit `conda install -c conda-forge lazygit`
   - [ ] Install all Mason packages `:MasonInstallAll`
   - [ ] `pip install beautysh black clang-format codespell debugpy mdformat pydocstyle pyright python-lsp-server ruff ruff-lsp sourcery`
   - [ ] Install `coc.nvim` by `cd ~/.local/share/nvim/lazy/coc.nvim/` and
         running `npm install`.
   - [ ] Check `:CocInfo` to ensure everything is working as expected.
   - [ ] Run `:CocConfig` and this to settings:
   ```json
   {
     "languageserver": {
       "sourcery": {
         "command": "<Command to run Sourcery>",
         "args": ["lsp"],
         "filetypes": ["python"],
         "initializationOptions": {
           "extension_version": "coc.vim",
           "editor_version": "vim"
         },
         "settings": {
           "sourcery": { "metricsEnabled": true }
         }
       }
     }
   }
   ```
