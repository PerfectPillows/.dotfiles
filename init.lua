-- Basic settings
-- Set <space> as the leader key
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
-- Hide the default mode indicator as lualine will show it
vim.opt.showmode = false
-- Set clipboard to always use system clipboard
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true

-- Install lazy.nvim if not already installed
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

-- Configure plugins
require("lazy").setup({

  -- Auto-pairing of brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup{}
    end
  },

  -- Theme
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
  -- Commenting plugin 
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any configuration here
    },
    lazy = false,
  },
  
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
  },
 
   -- Status Line Bottom
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
			  statusline = {'NvimTree'},
			  winbar = {},
		  },
		   ignore_focus = {'NvimTree'},
        },
      }
    end,
  },
  
   -- nvim-tree configuration 
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "right",
          width = 40,
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
  
	 -- Top Bar
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
  
  -- Indentation lines
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
  
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
	  "nvim-neotest/nvim-nio", 
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Set up nvim-dap-go
      -- Set up nvim-dap-go with detailed configuration
      require('dap-go').setup {
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
          {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
          {
            type = "go",
            name = "Debug App",
            request = "launch",
            program = "${workspaceFolder}/main.go",
			buildFlags = require("dap-go").get_build_flags,
          },
        },
        -- delve configurations
        delve = {
          -- the path to the executable dlv which will be used for debugging.
          -- by default, this is the "dlv" executable on your PATH.
          path = "dlv",
          -- time to wait for delve to initialize the debug session.
          -- default to 20 seconds
          initialize_timeout_sec = 50,
          -- a string that defines the port to start delve debugger.
          -- default to string "${port}" which instructs nvim-dap
          -- to start the process in a random available port.
          port = "${port}",
          -- additional args to pass to dlv
          args = {"--check-go-version=false", "--use-legacy-debugger=true"},
          -- the build flags that are passed to delve.
          -- defaults to empty string, but can be used to provide flags
          -- such as "-tags=unit" to make sure the test suite is
          -- compiled during debugging, for example.
          build_flags = "",
          -- whether the dlv process to be created detached or not.
          detached = vim.fn.has("win32") == 0,
          -- the current working directory to run dlv from, if other than
          -- the current working directory.
          cwd = nil,
        },
        -- options related to running closest test
        tests = {
          -- enables verbosity when running the test.
          verbose = false,
        },
      }

      -- Debugging keymaps
      vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F1>', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Set Breakpoint' })
      vim.keymap.set('n', '<S-F1>', function() require('dap').clear_breakpoints() end, { desc = 'Debug: Remove Breakpoint' })
      vim.keymap.set('n', '<A-S-F1>', function() require('dap').clear_breakpoints() end, { desc = 'Debug: Remove All Breakpoints' })
    end,
  },


  -- Telescope
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
            -- Add additional_args to include hidden files in live_grep
            additional_args = function(opts)
            return {"--hidden"}
            end
          },
	    },
		defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
		  path_display = { "smart" },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, 'fzf')

      -- Telescope live_grep in git root
      local function find_git_root()
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        if current_file == '' then
          current_dir = cwd
        else
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end
        local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
          print 'Not a git repository. Searching on current working directory'
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

      -- Telescope keymaps
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader>\\', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
	  vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols, { desc = '[F]ind [S]ymbols in current document' })
    end,
  },
})

-- Set up nvim-autopairs
local npairs = require("nvim-autopairs")
npairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
    javascript = {'template_string'},
    java = false,-- don't check treesitter on java
  }
})

-- If you want to automatically add spaces between parentheses
-- (|) becomes ( | )
local Rule = require('nvim-autopairs.rule')
npairs.add_rules {
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end)
}

-- Set up Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "tsserver", "gopls", "angularls" },
})

-- LSP
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
      -- Add these settings
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        upgrade_dependency = true,
      },
      usePlaceholders = true,
      completeUnimported = true,  -- auto-import completion items
      importShortcut = "Both",    -- Both: Keep existing and add if missing
    },
  },
})

-- TypeScript/JavaScript setup with tsserver
lspconfig.tsserver.setup({
  capabilities = capabilities,
  -- Add any specific settings for typescript-language-server here if needed
})


-- Angular setup
lspconfig.angularls.setup({
  capabilities = capabilities,
})

-- Set up autocompletion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Format on save for Go files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Quit nvim tree on all buffer close
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- KEYMAPS


--- Add keymaps for bufferline.nvim
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<cmd>BufferLineCyclePrev<cr>', opts)
map('n', '<A-.>', '<cmd>BufferLineCycleNext<cr>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<cmd>BufferLineMovePrev<cr>', opts)
map('n', '<A->>', '<cmd>BufferLineMoveNext<cr>', opts)

-- Pin/Unpin buffer
map('n', '<A-p>', '<cmd>BufferLineTogglePin<cr>', opts)

-- Close buffer
map('n', '<A-w>', '<cmd>bdelete<cr>', opts)

-- Force close buffer
map('n', '<A-W>', '<cmd>bdelete!<cr>', opts)

-- Close all but current buffer
map('n', '<A-P>', '<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>', opts)


-- LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	-- Add format keymap
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format({ async = false })
    end, { buffer = ev.buf, desc = "Format current buffer" })
  end,
})

-- Explicit Copy
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- keymaps for indentation 
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true, desc = "Indent left and reselect" })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true, desc = "Indent right and reselect" })
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true, desc = "Indent right and reselect" })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true, desc = "Indent left and reselect" })

-- keymaps for neo-tree
vim.api.nvim_set_keymap('n', '<leader>E', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
-- keymap to jump back to the editor
vim.api.nvim_set_keymap('n', '<leader>e', ':wincmd p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', ':NvimTreeOpen<CR>:lua require("nvim-tree.api").tree.expand_all()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', ':NvimTreeOpen<CR>:lua require("nvim-tree.api").tree.collapse_all()<CR>', { noremap = true, silent = true })


-- Keymaps to clear search highlights 
vim.api.nvim_set_keymap('n', '<leader>h', ':nohlsearch<CR>', {noremap = true, silent = true})

-- Movement with hjkl in insert mode 
vim.api.nvim_set_keymap('i', '<A-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-h>', '<C-Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<C-Right>', { noremap = true, silent = true })

-- Helper function to check if movement is possible
local function can_move(direction, start_line, end_line)
  local total_lines = vim.api.nvim_buf_line_count(0)
  if direction == "up" then
    return start_line > 1
  else
    return end_line < total_lines
  end
end

-- Function to move block
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
    print("Can't move " .. direction .. " any further!")
  end
end

-- Function to move single line
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
    print("Can't move " .. direction .. " any further!")
  end
end

-- key mappings for code block movement
vim.keymap.set("v", "<A-j>", function() move_block("down") end, { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", function() move_block("up") end, { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", function() move_line("down") end, { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", function() move_line("up") end, { noremap = true, silent = true })


