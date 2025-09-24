--
-- ~/.config/nvim/lua/configs/lsp.lua
--

-- Documentation for LSP configuration:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- local lspconfig = require "lspconfig"
local nonels = require "null-ls"

-- =============================================================================
-- Options

local LspConfig = {}

LspConfig.default = {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
}

LspConfig.default.capabilities.textDocument.completion.completionItem.snippetSupport =
    true

LspConfig.servers = {
    ["lua_ls"] = {},
    ["html"] = {},
    ["cssls"] = {},
    ["emmet_ls"] = {},
    ["clangd"] = {
        cmd = {
            "clangd",
            "--enable-config",
            "--fallback-style=llvm",
        },
    },
    ["pyright"] = {},
    ["ruff"] = {},
    ["bashls"] = {},
    ["ts_ls"] = {},
    ["tombi"] = {},
    ["tinymist"] = {},
}

local NoneLS = {}

NoneLS.formatters = {
    prettierd = {
        disabled_filetypes = { "html", "markdown" },
        env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/utils/.prettierrc.json",
        },
    },
    stylua = {},
    shfmt = { extra_args = { "-ci", "-sr" } },
}

-- =============================================================================
-- Neovim LSP Config

vim.lsp.config("*", {
    capabilities = LspConfig.default.capabilities,
})

for name, opts in pairs(LspConfig.servers) do
    if opts ~= {} then
        vim.lsp.config(name, opts)
    end
    vim.lsp.enable(name)
end

vim.diagnostic.config { float = { border = "single" } }

-- =============================================================================
-- None LS

local nonels_sources = {}

for name, opts in pairs(NoneLS.formatters) do
    if opts == {} then
        table.insert(nonels_sources, nonels.builtins.formatting[name])
    else
        table.insert(
            nonels_sources,
            nonels.builtins.formatting[name].with(opts)
        )
    end
end

nonels.setup { sources = nonels_sources }

-- =============================================================================
-- LSP Keymaps

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Attach",
    callback = function(event)
        local default_opts = { buffer = event.buf }
        vim.keymap.set(
            "n",
            "<LocalLeader>r",
            "<cmd>lua vim.lsp.buf.rename()<CR>",
            vim.tbl_deep_extend(
                "force",
                { desc = "Rename symbol under cursor" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "<LocalLeader>a",
            "<cmd>lua vim.lsp.buf.code_action()<CR>",
            vim.tbl_deep_extend(
                "force",
                { desc = "Run lsp code actions" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "<LocalLeader>l",
            "<cmd>lua vim.diagnostic.open_float()<CR>",
            vim.tbl_deep_extend(
                "force",
                { desc = "Open float for diagnostic under cursor" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "<LocalLeader>.",
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            vim.tbl_deep_extend(
                "force",
                { desc = "Next diagnostic" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "<LocalLeader>,",
            "<cmd>lua vim.diagnostic.goto_prev()<CR>",
            vim.tbl_deep_extend(
                "force",
                { desc = "Previous diagnostic" },
                default_opts
            )
        )
        vim.keymap.set(
            { "n", "x" },
            "<LocalLeader>f",
            function()
                vim.lsp.buf.format { async = false }
            end,
            vim.tbl_deep_extend(
                "force",
                { desc = "Format buffer" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "K",
            function()
                vim.lsp.buf.hover { border = "single" }
            end,
            vim.tbl_deep_extend(
                "force",
                { desc = "Open documentation for symbol under cursor" },
                default_opts
            )
        )
        vim.keymap.set(
            "n",
            "<LocalLeader>k",
            function()
                vim.lsp.buf.hover { border = "single" }
            end,
            vim.tbl_deep_extend(
                "force",
                { desc = "Open documentation for symbol under cursor" },
                default_opts
            )
        )
        vim.keymap.set(
            "i",
            "<C-s>",
            function()
                vim.lsp.buf.signature_help { border = "single" }
            end,
            vim.tbl_deep_extend(
                "force",
                { desc = "Open function signature" },
                default_opts
            )
        )
    end,
})
