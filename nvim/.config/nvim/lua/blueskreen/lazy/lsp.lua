return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
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
    -- Autoformatting
    "stevearc/conform.nvim",
    -- Schema information
    "b0o/SchemaStore.nvim",
  },

  config = function()
    -- vim.lsp.set_log_level("debug")

    require("neodev").setup {
      -- library = {
      --   plugins = { "nvim-dap-ui" },
      --   types = true,
      -- },
    }

    local cmp_lsp = require "cmp_nvim_lsp"
    local capabilities =
        vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

    require("fidget").setup {}

    require("mason").setup {}
    require("mason-lspconfig").setup {
      ensure_installed = {
        -- "stylua",
        "lua_ls",
        "tsserver",
        "tailwindcss",
        "cssls",
        "html",
        "ruby_lsp",
        "rust_analyzer",
        "gopls",
        "clangd",
        "yamlls",
        "bashls",
        "svelte",
        "jsonls",
        "yamlls",
        -- "ocamllsp",
        "lexical",
        "elixirls",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,

        ["lua_ls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          }
        end,

        ["ruby_lsp"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.ruby_lsp.setup {
            capabilities = capabilities,
            formatting = false,
            server_capabilities = {
              documentFormattingProvider = false,
            },
          }
          -- vim.print(lspconfig.ruby_lsp)
        end,

        -- ["rubocop"] = function()
        --   local lspconfig = require "lspconfig"
        --   lspconfig.rubocop.setup {
        --     capabilities = capabilities,
        --     cmd = { "rubocop", "--lsp" },
        --     root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        --   }
        --   -- vim.print(lspconfig.rubocop)
        -- end,

        -- ["sorbet"] = function()
        -- 	local lspconfig = require("lspconfig")
        -- 	lspconfig.sorbet.setup({
        -- 		capabilities = capabilities,
        -- 		root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        -- 		cmd = { "srb", "tc", "--lsp", "--dir=" .. vim.fn.getcwd() },
        -- 		init_options = {
        -- 			highlightUntyped = true,
        -- 		},
        -- 	})
        -- 	-- vim.print(lspconfig.sorbet)
        -- end,

        ["tailwindcss"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.tailwindcss.setup {
            capabilities = capabilities,
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  haml = "html",
                },
                experimental = {
                  classRegex = {
                    { 'class: ?"([^"]*)"',             "([a-zA-Z0-9\\-:]+)" },
                    { "(\\.[\\w\\-.]+)[\\n\\=\\{\\s]", "([\\w\\-]+)" },
                  },
                  --experimental = {
                  --  classRegex = {  -- for haml :D
                  --    "%\\w+([^\\s]*)",
                  --    "\\.([^\\.]*)",
                  --    ":class\\s*=>\\s*\"([^\"]*)",
                  --    "class:\\s+\"([^\"]*)"
                  --  }
                  --}
                },
              },
            },
          }
        end,

        ["gopls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.gopls.setup {
            capabilities = capabilities,
            settings = {
              gopls = {
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
              },
            },
          }
        end,

        ["tsserver"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.tsserver.setup {
            capabilities = capabilities,
            server_capabilities = {
              documentFormattingProvider = false,
            },
          }
        end,

        ["jsonls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.jsonls.setup {
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          }
        end,

        ["yamlls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.yamlls.setup {
            capabilities = capabilities,
            settings = {
              yaml = {
                schemaStore = {
                  enable = false,
                  url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          }
        end,

        -- ["ocamllsp"] = function()
        --   local lspconfig = require "lspconfig"
        --   lspconfig.ocamllsp.setup {
        --     capabilities = capabilities,
        --     manual_install = true,
        --     settings = {
        --       codelens = { enable = true },
        --       inlayHints = { enable = true },
        --     },

        --     filetypes = {
        --       "ocaml",
        --       "ocaml.interface",
        --       "ocaml.menhir",
        --       "ocaml.cram",
        --     },

        --     -- TODO: Check if i still need the filtypes stuff i had before
        --   }
        -- end,

        ["elixirls"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.elixirls.setup {
            capabilities = capabilities,
            cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/elixir-ls" },
            root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
            server_capabilities = {
              -- completionProvider = true,
              -- definitionProvider = false,
              documentFormattingProvider = false,
            },
          }
        end,

        ["lexical"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.lexical.setup {
            capabilities = capabilities,
            cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/lexical", "server" },
            root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
            server_capabilities = {
              completionProvider = vim.NIL,
              definitionProvider = false,
            },
          }
        end,

        ["clangd"] = function()
          local lspconfig = require "lspconfig"
          lspconfig.clangd.setup {
            capabilities = capabilities,
            -- TODO: Could include cmd, but not sure those were all relevant flags.
            init_options = { clangdFileStatus = true },
            filetypes = { "c", "cpp" },
            --    looks like something i would have added while i was floundering
          }
        end,
      },
    }

    local cmp = require "cmp"
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- this is the function that loads the extra snippets
    -- from rafamadriz/friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup {
      sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer",  keyword_length = 3 },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        -- ["<C-y>"] = cmp.mapping.confirm { select = true },
        -- confirm completion item
        ["<Enter>"] = cmp.mapping.confirm { select = true },

        -- trigger completion menu
        ["<C-Space>"] = cmp.mapping.complete(),
      },
    }

    -- Autoformatting Setup
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "prettier", "prettierd" } },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        ruby = { "ruby_lsp" },
      },
    }

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format { async = true, lsp_format = "fallback", range = range }
    end, { range = true })

    -- format on file save
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    -- 	callback = function(args)
    -- 		require("conform").format({
    -- 			bufnr = args.buf,
    -- 			lsp_fallback = true,
    -- 			quiet = true,
    -- 		})
    -- 	end,
    -- })

    vim.diagnostic.config {
      -- update_in_insert = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.INFO] = "⚑",
          [vim.diagnostic.severity.HINT] = "»",
        },
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }
  end,
}
