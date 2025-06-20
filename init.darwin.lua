
--[[

=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||     NEOVIM.BTW     ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||NORMAL..............||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

]]--

-- Basic Settings
-- set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.confirm = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- hide the default mode indicator as lualine will show it
vim.opt.showmode = false
-- set clipboard to always use system clipboard
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true

-- install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- configure plugins
require("lazy").setup({

  -- auto-pairing of brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup{}
    end
  },

  -- theme
  {
    "zootedb0t/citruszest.nvim", 
    lazy = false,
    priority = 1000,
    config = function()
      require("citruszest").setup({
        option = {
          bold = false,
          italic = false,
        },  })
        vim.cmd([[colorscheme citruszest]])
      end,
    },
    
    -- commenting plugin 
    {
      'numtostr/comment.nvim',
      opts = {
        -- add any configuration here
      },
      lazy = false,
    },

    -- lsp support
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
    },

    -- autocompletion
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",     
      },
    },
    
    -- Highlight, edit, and navigate code
    {         
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
    },

    -- status line bottom
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup {
          options = {
            icons_enabled = false,
            -- theme = 'catppuccin',
            component_separators = '|',
            section_separators = '',
            disabled_filetypes = {
              statusline = {'nvimtree'},
              winbar = {},
            },
            ignore_focus = {'nvimtree'},
          },
        }
      end,
    },

    -- start screen 
  {
    'goolord/alpha-nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      local alpha = require('alpha')
      local startify = require('alpha.themes.startify')

      -- Set the Apple logo ASCII art
      startify.section.header.val = {
        [[                                                                       ]],
        [[  ██████   █████                   █████   █████  ███                  ]],
        [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
        [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
        [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
        [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
        [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
        [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
        [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
        [[                                                                       ]],      }
      
      startify.section.header.opts = {
        position = "center",
        hl = "Type",
      }
      alpha.setup(startify.config)
    end
    }, 

    -- nvim-tree configuration 
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = true,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({
          view = {
            side = "right",
            width = 35,
            float = {
              enable = true,
              open_win_config = {
                border = "rounded",
                width = 35,
                height = vim.o.lines - 5,
                row = 1,
                col = vim.o.columns - 37, -- Position it on the right side
              },
            },
          },
          actions = {
            open_file = {
              quit_on_open = false,
            },
          },
          renderer = {
            group_empty = true,
          },
        })
      end,   
    },

    -- top bar
    {
      'akinsho/bufferline.nvim',
      version = "*",
      dependencies = 'nvim-tree/nvim-web-devicons',
      opts = {
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          indicator = {
            icon = '|',
            style = 'icon',
          },
          show_buffer_icons = false,
        }
      }
    },

    -- indentation lines
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
      config = function()
        require("ibl").setup {
          indent = {
            char = "¦",
          },
          scope = {
            enabled = true,
            show_start = true,
            show_end = false,
          },
        }
      end
    },	


    --lazy git 
    {
	    "kdheepak/lazygit.nvim",
	    lazy = true,
	    cmd = {
		    "LazyGit",
		    "LazyGitConfig",
		    "LazyGitCurrentFile",
		    "LazyGitFilter",
		    "LazyGitFilterCurrentFile",
	    },
	    -- optional for floating window border decoration
	    dependencies = {
		    "nvim-lua/plenary.nvim",
	    },
	    -- setting the keybinding for LazyGit with 'keys' is recommended in
	    -- order to load the plugin when the command is run for the first time
	    keys = {
		    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
	    }
    },


    -- telescope
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
      },
      config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')

        telescope.setup {
          pickers = {
            find_files = {
              previewer = false,
              hidden = true
            },
            git_files = {
              previewer = false,
            },
            live_grep = {
              -- add additional_args to include hidden files in live_grep
              additional_args = function(opts)
                return {"--hidden"}
              end
            },
          },
          defaults = {
            mappings = {
              i = {
                ['<c-u>'] = false,
                ['<c-d>'] = false,
              },
            },
            path_display = { "smart" },
          },
        }

        -- enable telescope fzf native, if installed
        pcall(telescope.load_extension, 'fzf')

        -- telescope live_grep in git root
        local function find_git_root()
          local current_file = vim.api.nvim_buf_get_name(0)
          local current_dir
          local cwd = vim.fn.getcwd()
          if current_file == '' then
            current_dir = cwd
          else
            current_dir = vim.fn.fnamemodify(current_file, ':h')
          end
          local git_root = vim.fn.systemlist('git -c ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
          if vim.v.shell_error ~= 0 then
            print 'not a git repository. searching on current working directory'
            return cwd
          end
          return git_root
        end

        local function live_grep_git_root()
          local git_root = find_git_root()
          if git_root then
            require('telescope.builtin').live_grep {
              search_dirs = { git_root },
            }
          end
        end

        vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

        -- telescope keymaps
        vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] find recently opened files' })
        vim.keymap.set('n', '<leader>\\', require('telescope.builtin').buffers, { desc = '[ ] find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] fuzzily search in current buffer' })
        vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'search [g]it [f]iles' })
        vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[s]earch [f]iles' })
        vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[s]earch [h]elp' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[s]earch current [w]ord' })
        vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[s]earch by [g]rep' })
        vim.keymap.set('n', '<leader>sg', ':LiveGrepGitRoot<cr>', { desc = '[s]earch by [g]rep on git root' })
        vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[s]earch [d]iagnostics' })
        vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[s]earch [r]esume' })
        vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols, { desc = '[f]ind [s]ymbols in current document' })
      end,
    },
  })

  -- set up nvim-autopairs
  local npairs = require("nvim-autopairs")
  npairs.setup({
    check_ts = true,
    ts_config = {
      lua = {'string'},-- it will not add a pair on that treesitter node
      javascript = {'template_string'},
      java = false,-- don't check treesitter on java
    }
  })

  -- if you want to automatically add spaces between parentheses
  -- (|) becomes ( | )
  local rule = require('nvim-autopairs.rule')
  npairs.add_rules {
    rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end)
  }

  -- set up mason
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls", "gopls" },
  })

  -- lsp
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- golang setup
  lspconfig.gopls.setup({
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
        -- add these settings
        codelenses = {
          gc_details = true,
          generate = true,
          regenerate_cgo = true,
          upgrade_dependency = true,
        },
        usePlaceholders = true,
        completeUnimported = true,  -- auto-import completion items
        importShortcut = "both",    -- both: keep existing and add if missing
      },
    },
  })

  -- typescript/javascript setup with tsserver
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    -- add any specific settings for typescript-language-server here if needed
  })

  -- set up autocompletion
  local cmp = require("cmp")
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<c-b>'] = cmp.mapping.scroll_docs(-4),
      ['<c-f>'] = cmp.mapping.scroll_docs(4),
      ['<c-space>'] = cmp.mapping.complete(),
      ['<cr>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- format on save for go files
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })

  -- quit nvim tree on all buffer close
  vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
      if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
        vim.cmd "quit"
      end
    end
  })

  -- keymaps


  --- add keymaps for bufferline.nvim
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  -- move to previous/next
  map('n', '<c-,>', '<cmd>BufferLineCyclePrev<cr>', opts)
  map('n', '<c-.>', '<cmd>BufferLineCycleNext<cr>', opts)

  -- re-order to previous/next
  map('n', '<leader>,', '<cmd>BufferLineMovePrev<cr>', opts)
  map('n', '<leader>.', '<cmd>BufferLineMoveNext<cr>', opts)

  -- pin/unpin buffer
  map('n', '<leader>p', '<cmd>BufferLineTogglePin<cr>', opts)

  -- close buffer
  map('n', '<c-w>', '<cmd>bdelete<cr>', opts)

  -- force close buffer
  map('n', '<leader>W', '<cmd>bdelete!<cr>', opts)

  -- close all but current buffer
  map('n', '<leader>P', '<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>', opts)


  -- lsp keybindings
  vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('userlspconfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>se', vim.diagnostic.open_float, opts)  -- Show error details in floating window
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)        -- Go to previous diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)        -- Go to next diagnostic
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts) -- Show all diagnostics in location list
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)  -- Show code actions
    -- add format keymap
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format({ async = false })
    end, { buffer = ev.buf, desc = "format current buffer" })
  end,
  })

  -- explicit copy
  vim.keymap.set('v', '<c-c>', '"+y', { noremap = true, silent = true, desc = "copy to system clipboard" })
  vim.keymap.set('n', '<c-v>', '"+p', { noremap = true, silent = true, desc = "paste from system clipboard" })

  -- keymaps for indentation 
  vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = "indent left and reselect" })
  vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = "indent right and reselect" })
  vim.keymap.set('v', '<tab>', '>gv', { noremap = true, silent = true, desc = "indent right and reselect" })
  vim.keymap.set('v', '<s-tab>', '<gv', { noremap = true, silent = true, desc = "indent left and reselect" })

  -- keymaps for nvim-tree
  vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>E', ':NvimTreeFocus<cr>', { noremap = true, silent = true })
  -- keymap to jump back to the editor
  vim.api.nvim_set_keymap('n', '<leader>1', ':wincmd p<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>3', ':NvimTreeOpen<cr>:lua require("nvim-tree.api").tree.expand_all()<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>4', ':NvimTreeOpen<cr>:lua require("nvim-tree.api").tree.collapse_all()<cr>', { noremap = true, silent = true })


  -- keymaps to clear search highlights 
  vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<cr>', {noremap = true, silent = true})

  -- movement with hjkl in insert mode 
  vim.api.nvim_set_keymap('i', '<c-h>', '<left>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<c-j>', '<down>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<c-k>', '<up>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<c-l>', '<right>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<c-H>', '<c-left>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<c-L>', '<c-right>', { noremap = true, silent = true })

  -- helper function to check if movement is possible
  local function can_move(direction, start_line, end_line)
    local total_lines = vim.api.nvim_buf_line_count(0)
    if direction == "up" then
      return start_line > 1
    else
      return end_line < total_lines
    end
  end

  -- function to move block
  local function move_block(direction)
    local start_line, end_line, _ = unpack(vim.fn.getpos("'<"), 2)
    end_line = vim.fn.getpos("'>")[2]

    if can_move(direction, start_line, end_line) then
      if direction == "up" then
        vim.cmd(":'<,'>move '<-2")
      else
        vim.cmd(":'<,'>move '>+1")
      end
      vim.cmd("normal! gv=gv")
    else
      print("can't move " .. direction .. " any further!")
    end
  end

  -- function to move single line
  local function move_line(direction)
    local line_num = vim.fn.line('.')

    if can_move(direction, line_num, line_num) then
      if direction == "up" then
        vim.cmd("move -2")
      else
        vim.cmd("move +1")
      end
      vim.cmd("normal! ==")
    else
      print("can't move " .. direction .. " any further!")
    end
  end

  -- key mappings for code block movement
  vim.keymap.set("v", "<c-j>", function() move_block("down") end, { noremap = true, silent = true })
  vim.keymap.set("v", "<c-k>", function() move_block("up") end, { noremap = true, silent = true })
  vim.keymap.set("n", "<c-j>", function() move_line("down") end, { noremap = true, silent = true })
  vim.keymap.set("n", "<c-k>", function() move_line("up") end, { noremap = true, silent = true })