local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "User AstroFile",
    opts = { suggestion = { auto_trigger = true, debounce = 150 } },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = function(_, opts)
      local cmp, copilot = require "cmp", require "copilot.suggestion"
      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      if not opts.mapping then
        opts.mapping = {}
      end
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if copilot.is_visible() then
          copilot.accept()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" })
      opts.mapping["<C-x>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.next()
        end
      end)
      opts.mapping["<C-z>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.prev()
        end
      end)
      opts.mapping["<C-right>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.accept_word()
        end
      end)
      opts.mapping["<C-l>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.accept_word()
        end
      end)
      opts.mapping["<C-down>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.accept_line()
        end
      end)
      opts.mapping["<C-j>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.accept_line()
        end
      end)
      opts.mapping["<C-c>"] = cmp.mapping(function()
        if copilot.is_visible() then
          copilot.dismiss()
        end
      end)
      return opts
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- add which-key mapping descriptions for VimTex
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Set up VimTex Which-Key descriptions",
        group = vim.api.nvim_create_augroup("vimtex_mapping_descriptions", { clear = true }),
        pattern = "tex",
        callback = function(event)
          local wk = require "which-key"
          local opts = {
            mode = "n", -- NORMAL mode
            buffer = event.buf, -- Specify a buffer number for buffer local mappings to show only in tex buffers
          }
          local mappings = {
            ["<localleader>l"] = {
              name = "+VimTeX",
              a = "Show Context Menu",
              C = "Full Clean",
              c = "Clean",
              e = "Show Errors",
              G = "Show Status for All",
              g = "Show Status",
              i = "Show Info",
              I = "Show Full Info",
              k = "Stop VimTeX",
              K = "Stop All VimTeX",
              L = "Compile Selection",
              l = "Compile",
              m = "Show Imaps",
              o = "Show Compiler Output",
              q = "Show VimTeX Log",
              s = "Toggle Main",
              t = "Open Table of Contents",
              T = "Toggle Table of Contents",
              v = "View Compiled Document",
              X = "Reload VimTeX State",
              x = "Reload VimTeX",
            },
            ["ts"] = {
              name = "VimTeX Toggles & Cycles", -- optional group name
              ["$"] = "Cycle inline, display & numbered equation",
              c = "Toggle star of command",
              d = "Cycle (), \\left(\\right) [,...]",
              D = "Reverse Cycle (), \\left(\\right) [, ...]",
              e = "Toggle star of environment",
              f = "Toggle a/b vs \\frac{a}{b}",
            },
            ["[/"] = "Previous start of a LaTeX comment",
            ["[*"] = "Previous end of a LaTeX comment",
            ["[["] = "Previous beginning of a section",
            ["[]"] = "Previous end of a section",
            ["[m"] = "Previous \\begin",
            ["[M"] = "Previous \\end",
            ["[n"] = "Previous start of a math zone",
            ["[N"] = "Previous end of a math zone",
            ["[r"] = "Previous \\begin{frame}",
            ["[R"] = "Previous \\end{frame}",
            ["]/"] = "Next start of a LaTeX comment %",
            ["]*"] = "Next end of a LaTeX comment %",
            ["]["] = "Next beginning of a section",
            ["]]"] = "Next end of a section",
            ["]m"] = "Next \\begin",
            ["]M"] = "Next \\end",
            ["]n"] = "Next start of a math zone",
            ["]N"] = "Next end of a math zone",
            ["]r"] = "Next \\begin{frame}",
            ["]R"] = "Next \\end{frame}",
            ["cs"] = {
              c = "Change surrounding command",
              e = "Change surrounding environment",
              ["$"] = "Change surrounding math zone",
              d = "Change surrounding delimiter",
            },
            ["ds"] = {
              c = "Delete surrounding command",
              e = "Delete surrounding environment",
              ["$"] = "Delete surrounding math zone",
              d = "Delete surrounding delimiter",
            },
          }
          wk.register(mappings, opts)
          -- VimTeX Text Objects without variants with targets.vim
          opts = {
            mode = "o", -- Operator pending mode
            buffer = event.buf,
          }
          local objects = {
            ["ic"] = [[LaTeX Command]],
            ["ac"] = [[LaTeX Command]],
            ["id"] = [[LaTeX Math Delimiter]],
            ["ad"] = [[LaTeX Math Delimiter]],
            ["ie"] = [[LaTeX Environment]],
            ["ae"] = [[LaTeX Environment]],
            ["i$"] = [[LaTeX Math Zone]],
            ["a$"] = [[LaTeX Math Zone]],
            ["iP"] = [[LaTeX Section, Paragraph, ...]],
            ["aP"] = [[LaTeX Section, Paragraph, ...]],
            ["im"] = [[LaTeX Item]],
            ["am"] = [[LaTeX Item]],
          }
          wk.register(objects, opts)
        end,
      })
    end,
  },

  {
    {
      "ggandor/leap.nvim",
      keys = {
        { "s", "<Plug>(leap-forward-to)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
        { "S", "<Plug>(leap-backward-to)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
        { "x", "<Plug>(leap-forward-till)", mode = { "x", "o" }, desc = "Leap forward till" },
        { "X", "<Plug>(leap-backward-till)", mode = { "x", "o" }, desc = "Leap backward till" },
        { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
      },
      opts = {},
      init = function() -- https://github.com/ggandor/leap.nvim/issues/70#issuecomment-1521177534
        vim.api.nvim_create_autocmd("User", {
          callback = function()
            vim.cmd.hi("Cursor", "blend=100")
            vim.opt.guicursor:append { "a:Cursor/lCursor" }
          end,
          pattern = "LeapEnter",
        })
        vim.api.nvim_create_autocmd("User", {
          callback = function()
            vim.cmd.hi("Cursor", "blend=0")
            vim.opt.guicursor:remove { "a:Cursor/lCursor" }
          end,
          pattern = "LeapLeave",
        })
      end,
      dependencies = {
        "tpope/vim-repeat",
      },
    },
    {
      "catppuccin/nvim",
      optional = true,
      opts = { integrations = { leap = true } },
    },
  },

  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- This keeps it pinned to semantic releases
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- This would be an optional dependency eventually
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    lazy = false,
  },

  "NvChad/nvcommunity",
  { import = "nvcommunity.diagnostics.trouble" },
  { import = "nvcommunity.editor.biscuits" },
  { import = "nvcommunity.editor.hlargs" },
  { import = "nvcommunity.editor.illuminate" },
  { import = "nvcommunity.editor.rainbowdelimiters" },
  { import = "nvcommunity.editor.symbols-outline" },
  { import = "nvcommunity.editor.telescope-undo" },
  { import = "nvcommunity.git.diffview" },
  { import = "nvcommunity.git.lazygit" },
  { import = "nvcommunity.lsp.dim" },
  { import = "nvcommunity.lsp.prettyhover" },
  { import = "nvcommunity.motion.neoscroll" },
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  { "folke/todo-comments.nvim", event = "BufRead" },
  { "f-person/git-blame.nvim", event = "BufRead" },
  { "zeioth/garbage-day.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/lsp_signature.nvim",
      opts = {
        hint_enable = false,
      },
    },
  },
}

return plugins
