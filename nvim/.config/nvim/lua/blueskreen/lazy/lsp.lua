return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "VonHeikemen/lsp-zero.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    -- local cmp_lsp = require("cmp_nvim_lsp")
    -- local capabilities = vim.tbl_deep_extend(
    --   "force",
    --   {},
    --   vim.lsp.protocol.make_client_capabilities(),
    --   cmp_lsp.default_capabilities())

    require("fidget").setup({})

    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
      -- keybindings are listed here:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/api-reference.md#default_keymapsopts
      lsp_zero.default_keymaps({buffer = bufnr})
    end)

    -- technically these are "diagnostic signs"
    -- neovim enables them by default.
    -- here we are just changing them to fancy icons.
    lsp_zero.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    -- to learn how to use mason.nvim
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'tsserver',
        'tailwindcss',
        'cssls',
        'ruby_lsp',
        'rust_analyzer',
        'gopls',
        'clangd',
        'cmake',
        'yamlls',
        'bashls',
        'ansiblels',
        'eslint',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,

        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,

        ["tailwindcss"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.tailwindcss.setup {
            capabilities = capabilities,
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  haml = "html"
                },
                experimental = {
                  classRegex = {
                    { "class: ?\"([^\"]*)\"", "([a-zA-Z0-9\\-:]+)" },
                    { "(\\.[\\w\\-.]+)[\\n\\=\\{\\s]", "([\\w\\-]+)" },
                  }
                  --experimental = {
                  --  classRegex = {  -- for haml :D
                  --    "%\\w+([^\\s]*)",
                  --    "\\.([^\\.]*)",
                  --    ":class\\s*=>\\s*\"([^\"]*)",
                  --    "class:\\s+\"([^\"]*)"
                  --  }
                  --}
                }
              }
            }
          }
        end,
      }
    })

    local cmp = require('cmp')
    local cmp_action = lsp_zero.cmp_action()
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- this is the function that loads the extra snippets
    -- from rafamadriz/friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'luasnip', keyword_length = 2},
        {name = 'buffer', keyword_length = 3},
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        -- confirm completion item
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),

        -- trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- scroll up and down the documentation window
        -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- navigate between snippet placeholders
        ['<Tab>'] = cmp_action.luasnip_jump_forward(),
        ['<C-Tab>'] = cmp_action.luasnip_jump_backward(),
      }),
      -- note: if you are going to use lsp-kind (another plugin)
      -- replace the line below with the function from lsp-kind
      formatting = lsp_zero.cmp_format({details = true}),
    })

    -- vim.diagnostic.config({
    --   -- update_in_insert = true,
    --   float = {
    --     focusable = false,
    --     style = "minimal",
    --     border = "rounded",
    --     source = "always",
    --     header = "",
    --     prefix = "",
    --   },
    -- })
  end
}

