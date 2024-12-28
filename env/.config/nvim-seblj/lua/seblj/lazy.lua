local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }):wait()
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy.view.config").keys.hover = "gh"
require("lazy").setup("config", {
    ui = {
        border = CUSTOM_BORDER,
        backdrop = 100,
    },
    install = {
        colorscheme = { COLORSCHEME },
    },
})
