return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- the main branch does not support lazy-loading
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    ts.install {
      "vimdoc",
      "vim",
      "javascript",
      "typescript",
      "ruby",
      "c",
      "cpp",
      "lua",
      -- "rust",
      "sql",
      -- "go",
      -- "dockerfile",
      "css",
      "html",
      -- "clojure",
      -- "graphql",
      "json",
      "yaml",
      "jsdoc",
      "bash",
      "make",
    }

    -- Filetypes that also keep vim's regex syntax highlighting on
    local regex_highlight = { markdown = true }

    local function attach(buf, lang)
      if not pcall(vim.treesitter.start, buf, lang) then
        return
      end
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      if regex_highlight[vim.bo[buf].filetype] then
        vim.bo[buf].syntax = "on"
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("json3b_treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        if vim.list_contains(ts.get_installed(), lang) then
          attach(args.buf, lang)
        elseif vim.list_contains(ts.get_available(), lang) then
          -- Automatically install missing parsers when entering buffer
          ts.install(lang):await(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              attach(args.buf, lang)
            end
          end)
        end
      end,
    })
  end,
}
