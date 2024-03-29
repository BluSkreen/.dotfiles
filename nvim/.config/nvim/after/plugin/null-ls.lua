local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local formatting = null_ls.builtins.formatting
-- 'yamlfmt',
-- 'xmlformatter',
-- 'sqlfmt',
--
-- 'black',

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = { "--tab-width 4" } }),
        formatting.stylua,
    },
})
