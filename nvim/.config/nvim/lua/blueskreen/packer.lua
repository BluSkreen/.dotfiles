-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim' }

    use {
        'folke/tokyonight.nvim',
        as = 'tokyonight',
        config = function()
            -- vim.cmd('colorscheme tokyonight-storm')
            require("tokyonight").setup({
              style = "moon",
            })
        end,
    }

    use {
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
    }

    use { "folke/zen-mode.nvim" }
    use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { 'nvim-treesitter/playground' }
    use { 'theprimeagen/harpoon' }
    use { 'ThePrimeagen/vim-be-good' }
    use { 'mbbill/undotree' }
    use { "tpope/vim-fugitive" }
    use { "nvim-treesitter/nvim-treesitter-context" };

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
        requires = { "nvim-lua/plenary.nvim" },
    }

end)

    --use({
    --    'rose-pine/neovim',
    --    as = 'rose-pine',
    --    config = function()
    --        vim.cmd('colorscheme rose-pine')
    --    end
    -- })

    --use ({
    --    "catppuccin/nvim",
    --    as = "catppuccin",
    --    config = function()
    --        vim.cmd('colorscheme catppuccin-macchiato')
    --    end
    --})
