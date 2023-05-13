require("tokyonight").setup({
    style = "storm"
})

function ColorMyPencils(color)
--    color = color or "catppuccin-macchiato"
--    vim.cmd.colorscheme(color)

--    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    color = color or "tokyonight"

    vim.cmd.colorscheme(color)

end

ColorMyPencils()
