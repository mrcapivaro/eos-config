local treesitter_configs = require("nvim-treesitter.configs")

-- Use git instead of curl.
require("nvim-treesitter.install").prefer_git = true

---@diagnostic disable-next-line: missing-fields
treesitter_configs.setup({
    ensure_installed = {
        "vim",
        "vimdoc",
        "query",
        "regex",
        "lua",
        "luadoc",
        "luap",
        "bash",
        "markdown",
        "markdown_inline",
        "typst",
        "latex", -- requires tree-sitter-cli installed
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "cpp",
        "rust",
        "go",
        "python",
        "toml",
        "yaml",
        "ini",
        "json",
    },
    auto_install = true,
    indent = { enable = true, disable = { "html" } },
    -- incremental_selection = {
    --     enable = false,
    --     keymaps = {
    --         -- set to `false` to disable one of the mappings
    --         init_selection = false, -- gnn
    --         node_incremental = "grn",
    --         scope_incremental = "grc",
    --         node_decremental = "grm",
    --     },
    -- },
    highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 200 * 1024
            local ok, stats =
                pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
})
