local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- custom stuff
    "beautysh",
    "bibtex-tidy",
    "black",
    "clang-format",
    "clangd",
    "codespell",
    "debugpy",
    "fixjson",
    "grammarly-languageserver",
    "isort",
    "latexindent",
    "ltex-ls",
    "luaformatter",
    "markdownlint",
    "mdformat",
    "pydocstyle",
    "pyright",
    "python-lsp-server",
    "ruff",
    "ruff-lsp",
    "shellcheck",
    "sourcery",
    "texlab",
    "textlint",
    "write-good",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
