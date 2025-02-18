vim.treesitter.language.register("bash", "zsh")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"

        -- Only enable indentexpr if the lang contains queries for indents
        -- Otherwise it will just mess everything up in C# at least
        local lang = vim.treesitter.language.get_lang(vim.bo.ft) or vim.bo.ft
        if vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
    end,
})

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c_sharp" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     build = ":TSUpdate",
    --     config = function()
    --         require("nvim-treesitter.configs").setup({
    --             ensure_installed = { "c_sharp" },
    --         })
    --     end,
    -- },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = { "BufReadPost", "BufNewFile" },
        branch = "main",
        config = function()
            require("nvim-treesitter-textobjects").setup()
            local function map_select(mode, lhs, query)
                vim.keymap.set(mode, lhs, function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
                end)
            end

            map_select({ "x", "o" }, "if", "@function.inner")
            map_select({ "x", "o" }, "af", "@function.outer")
            map_select({ "x", "o" }, "ic", "@class.inner")
            map_select({ "x", "o" }, "ac", "@class.outer")

            -- Swap
            local swap = require("nvim-treesitter-textobjects.swap")

            ---@param swap_fn fun(query_string_regex: string)
            ---@param query_string_regex string
            local function wrap_swap(swap_fn, query_string_regex)
                return function()
                    swap_fn(query_string_regex)
                end
            end

            vim.keymap.set("n", "<leader>sa", wrap_swap(swap.swap_next, "@parameter.inner"))
            vim.keymap.set("n", "<leader>sf", wrap_swap(swap.swap_next, "@function.outer"))

            vim.keymap.set("n", "<leader>sA", wrap_swap(swap.swap_previous, "@parameter.inner"))
            vim.keymap.set("n", "<leader>sF", wrap_swap(swap.swap_previous, "@function.outer"))
        end,
    },
}
