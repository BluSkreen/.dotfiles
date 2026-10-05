# nvim config notes

## 2026-10-04: plugin update fallout (Neovim 0.12)

A plugin update moved nvim-treesitter to its rewritten `main` branch and
mason-lspconfig to v2, which broke treesitter on startup and silently disabled
all per-server LSP settings. Everything below was changed to fix that.

### treesitter (`lua/json3b/lazy/treesitter.lua`)

The `main` branch removed `require("nvim-treesitter.configs").setup{}`,
`ensure_installed`, the `highlight`/`indent` modules, `auto_install` and
`parsers.get_parser_configs()`.

- Spec now has `branch = "main"` and `lazy = false` (main can't be lazy-loaded).
- Parsers are installed with `require("nvim-treesitter").install{...}` (same list).
- A `FileType` autocmd does what the old modules did: starts highlighting with
  `vim.treesitter.start()`, sets the treesitter `indentexpr`, and installs a
  missing parser on first use (old `auto_install = true`).
- Markdown still keeps vim regex syntax on (old `additional_vim_regex_highlighting`).
- Removed the custom `templ` parser registration (API gone, and `templ` was
  already commented out of the list). To bring it back on main, register it in
  a `User TSUpdate` autocmd via `require("nvim-treesitter.parsers").templ = {...}`.
  The old block was:

  ```lua
  local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  treesitter_parser_config.templ = {
    install_info = {
      url = "https://github.com/vrischmann/tree-sitter-templ.git",
      files = { "src/parser.c", "src/scanner.c" },
      branch = "master",
    },
  }
  vim.treesitter.language.register("templ", "templ")
  ```

### LSP (`lua/json3b/lazy/lsp.lua`)

mason-lspconfig v2 ignores `handlers = {...}`; it just calls `vim.lsp.enable()`
on installed servers (`automatic_enable`). So jsonls/yamlls had no schemas,
lua_ls had no custom globals, clangd ignored its custom cmd, and cmp
capabilities weren't sent to any server.

- Per-server setup moved from `require("lspconfig").X.setup{}` in handlers to
  `vim.lsp.config("X", {...})`. Capabilities go on `vim.lsp.config("*", ...)`.
  mason-lspconfig still installs/enables everything in `ensure_installed`.
- lua_ls: dropped `runtime = { version = "Lua 5.1" }` (lazydev sets runtime);
  globals kept.
- `neodev.nvim` (deprecated) replaced by `folke/lazydev.nvim` (own spec,
  `ft = "lua"`, includes luv types and nvim-dap-ui), plus a `lazydev` cmp source.
- Removed the LazyVim-style `opts = { servers = { ruby_lsp = ... } }` block. lazy.nvim
  never used it because the spec has its own `config`, and
  `~/.rbenv/shims/ruby-lsp` didn't exist. It was:

  ```lua
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      },
    },
  },
  ```

  New-style equivalent if needed: `vim.lsp.config("ruby_lsp", { cmd = {...} })`
  then `vim.lsp.enable("ruby_lsp")` (mason won't enable it since it's not installed by mason).
- Removed a commented-out duplicate of the clangd setup (identical to the live one).
- The commented-out gopls block was converted to `vim.lsp.config` form (still commented).
- Tailwind: converted to a commented `vim.lsp.config("tailwindcss", ...)` with
  only `includeLanguages`; the experimental classRegex parts were dropped.
  Original block, verbatim:

  ```lua
  --["tailwindcss"] = function()
  --  local lspconfig = require "lspconfig"
  --  lspconfig.tailwindcss.setup {
  --    capabilities = capabilities,
  --    settings = {
  --      tailwindCSS = {
  --        includeLanguages = {
  --          haml = "html",
  --        },
  --        --experimental = {
  --        --  classRegex = {
  --        --    { 'class: ?"([^"]*)"',             "([a-zA-Z0-9\\-:]+)" },
  --        --    { "(\\.[\\w\\-.]+)[\\n\\=\\{\\s]", "([\\w\\-]+)" },
  --        --  },
  --        --  --experimental = {
  --        --  --  classRegex = {  -- for haml :D
  --        --  --    "%\\w+([^\\s]*)",
  --        --  --    "\\.([^\\.]*)",
  --        --  --    ":class\\s*=>\\s*\"([^\"]*)",
  --        --  --    "class:\\s+\"([^\"]*)"
  --        --  --  }
  --        --  --}
  --        --},
  --      },
  --    },
  --  }
  --end,
  ```

  To use it now, uncomment the `vim.lsp.config("tailwindcss", ...)` block in
  lsp.lua and put `experimental = { classRegex = {...} }` inside `tailwindCSS`.
- conform: `javascript = { { "prettier", "prettierd" } }` (removed syntax) became
  `{ "prettierd", "prettier", stop_after_first = true }`.
- `vim.diagnostic.config` float: `source = "always"` became `source = true`.

### Other files

- `lazy/dap.lua`: removed `vim.print(bin_locations)`, which printed
  `~/.local/share/nvim/mason/bin/` on every startup.
- `init.lua`: removed the `[d`/`]d` maps. They were swapped (`[d` went to
  next) and used deprecated `goto_next/goto_prev`. Neovim 0.11+ has built-in
  `]d` next / `[d` prev. Also `vim.highlight.on_yank` became `vim.hl.on_yank`.
- `lazy_init.lua`: `vim.loop` became `vim.uv`.
- `lazy/trouble.lua` (v3 API): `setup({ icons = false })` became `setup({})`, and
  `toggle()` became `toggle("diagnostics")`.
- `lazy/gitsigns.lua`: removed `<leader>hu` (`undo_stage_hunk`, deprecated; use
  `<leader>hs` on a staged hunk to unstage). `<leader>td` now runs
  `preview_hunk_inline` instead of the deprecated `toggle_deleted`.
- `lazy/colors.lua`: tokyonight and rose-pine are `lazy = true` and only run
  their `setup()`. Before, both loaded at startup, each applied its own colorscheme
  and then switched back to everforest. Everforest's config now calls
  `ColorMyPencils("everforest")` (same look: everforest, transparent bg).
  `:colorscheme tokyonight` / `rose-pine` still works (lazy loads them on demand).
- Ran `:Lazy clean` (removed leftover LazyVim plugins) and `:Lazy sync`.

### Known loose ends (not changed)

- Harpoon `<C-m>` is the same key as `<CR>` in many terminals, so it can hijack
  Enter in normal mode, e.g. jumping from the quickfix list.
- `<leader>f` uses `vim.lsp.buf.format`; conform formatters only run via `:Format`.
- prettier/prettierd and rubocop aren't installed, so conform can't format
  js/html/css/json/ruby.
- neotest is loaded at startup with an empty config.
- The commented ruby_lsp/rubocop blocks in lsp.lua still use the old
  `lspconfig.X.setup` API; convert to `vim.lsp.config` if revived.
