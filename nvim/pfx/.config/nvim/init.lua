--
-- ~/.config/nvim/init.lua
--

---@diagnostic disable: unused-function
---@diagnostic disable: unused-local
---@diagnostic disable: redefined-local

-- =============================================================================
-- = Settings ==================================================================
-- =============================================================================

-- stylua: ignore start

-- == Basic ====================================================================

vim.opt.number         = false
vim.opt.relativenumber = false
vim.opt.cursorline     = true
vim.opt.wrap           = false
vim.opt.scrolloff      = 16
vim.opt.sidescrolloff  = 8

-- == Identation ===============================================================

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.softtabstop    = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.autoindent     = true

-- == Search ===================================================================

vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.hlsearch       = true
vim.opt.incsearch      = true
vim.opt.grepprg        = "rg --vimgrep -uu --follow --hidden"

-- == Visual ===================================================================

vim.opt.modeline       = false
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "81"
vim.opt.showmatch      = true
vim.opt.matchtime      = 2
vim.opt.cmdheight      = 1
vim.opt.laststatus     = 3
vim.opt.completeopt    = "menuone,noinsert,noselect"
vim.opt.showmode       = false
vim.opt.pumheight      = 10
vim.opt.pumblend       = 10
vim.opt.winblend       = 0
vim.opt.lazyredraw     = true
vim.opt.synmaxcol      = 300
vim.opt.conceallevel   = 2
vim.opt.concealcursor:remove("n")

-- == Whitespaces ==============================================================

vim.opt.list         = true
vim.opt.listchars    = { space = "·", tab = ">·", eol = "¬" }

-- == Leader Keys ==============================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = ","
vim.opt.timeoutlen   = 500
vim.opt.ttimeoutlen  = 0

-- == File Handling ============================================================

vim.opt.backup       = false
vim.opt.writebackup  = false
vim.opt.swapfile     = false
vim.opt.autowrite    = false
vim.opt.undofile     = true
vim.opt.updatetime   = 50
vim.opt.autoread     = true

-- == Behavior =================================================================

vim.opt.hidden       = true
vim.opt.errorbells   = false
vim.opt.backspace    = "indent,eol,start"
vim.opt.autochdir    = false
vim.opt.virtualedit  = "block"
-- vim.opt.selection    = "exclusive"
vim.opt.mouse        = "a"
vim.opt.modifiable   = true
vim.opt.encoding     = "UTF-8"
vim.opt.clipboard:append("unnamedplus")
---@diagnostic disable-next-line: undefined-field
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")

-- == Splits ===================================================================

vim.opt.splitbelow = true
vim.opt.splitright = true

-- == Folds ====================================================================
-- https://www.reddit.com/r/neovim/comments/1d3iwcz/custom_folds_without_any_plugins/

vim.wo.foldmethod  = "marker"
-- vim.wo.foldexpr  = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldmarker   = "{{{,}}}"
-- vim.opt.foldminlines = 1
-- vim.opt.foldlevel    = 99
-- vim.opt.foldcolumn   = "auto:1"
vim.opt.fillchars:append("fold:-")

-- stylua: ignore end

-- =============================================================================
-- = Helpers ===================================================================
-- =============================================================================

local setmap = function(maps)
    for _, map in ipairs(maps) do
        local mode = map[1] or map.mode
        if type(map) == "string" then
            map = type(map) == "string" and { map } or map
        end

        local lhs = map[2] or map.lhs
        local rhs = map[3] or map.rhs
        local desc = map[4] or map.desc or ""

        local options = map[5] or map.opts or {}
        local default_options = {
            silent = true,
            expr = false,
            nowait = false,
            desc = desc,
        }
        options = vim.tbl_deep_extend("force", default_options, options)

        vim.keymap.set(unpack(mode), lhs, rhs, options)
    end
end

local cmd = function(str)
    return ":" .. str .. "<CR>"
end

local shell = function(str)
    return ":!" .. str .. "<CR>"
end

local leader = function(str)
    return "<Leader>" .. str
end

local lleader = function(str)
    return "<LocalLeader>" .. str
end

local normal = { "n" }
local visual = { "v" }
local line = { "x" }
-- local selection = { visual, line }
local non_insert = { normal, visual, line }
local insert = { "i" }
local all = { normal, visual, line, insert }
-- local insert_completion = { "ic" }
-- local operator = { "o" }
-- local replace = { "R" }

-- =============================================================================
-- = Plugins ===================================================================
-- =============================================================================

-- == Plugin Manager Bootstrap  ================================================

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set("n", "<Leader>ip", ":Lazy<CR>")

-- == Plugin Declarations  =====================================================

local plugin_list = {}

local add = function(args)
    table.insert(plugin_list, args)
end

-- --- Appearance --------------------------------------------------------------

local colors = require("colors").gruvbox
add {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme "gruvbox"
    end,
    opts = {
        italic = {
            strings = false,
            comments = false,
            folds = false,
            emphasis = false,
        },
        overrides = {
            Whitespace = { fg = colors.dark0_soft },
            NonText = { fg = colors.dark0_soft },
            ColorColumn = { bg = colors.dark0_soft, },
            CursorLine = { bg = colors.dark0_soft, },
            SignColumn = { bg = colors.dark0 },
            NormalFloat = { bg = colors.dark0 },
            Pmenu = { bg = colors.dark0 },
            PmenuSel = { fg = colors.dark0_hard, bg = colors.neutral_yellow },
        },
    },
}

-- TABLINE:    Buffers                         ...   Cwd
-- STATUSLINE: Mode | [GitStatus] | FileName   ...   FileData | Position
local CwdComponent = function()
    -- Disabled filetypes
    if vim.bo.filetype == "man" or vim.bo.filetype == "help" then
        return ""
    end
    --
    local cwd = vim.fn.getcwd()
    local home = vim.fn.getenv "HOME"
    local result = cwd:gsub(home, "~")
    --
    local dirs = vim.split(result, "/")
    if #dirs >= 7 then
        result = table.concat(dirs, "/", 1, 2)
            .. "/.../"
            .. table.concat(dirs, "/", 7)
    end
    return result
end

add {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "location" },
            lualine_c = {},
            lualine_x = {
                {
                    "diff",
                    source = function()
                        local gitstatus = vim.b.gitsigns_status_dict or {}
                        return {
                            added = gitstatus.added,
                            removed = gitstatus.removed,
                            modified = gitstatus.changed,
                        }
                    end,
                },
            },
            lualine_y = { "branch" },
            lualine_z = { CwdComponent },
        },
        tabline = {
            lualine_a = { "buffers" },
            lualine_x = { "lsp_status", "diagnostics", "filesize" },
        },
    },
}

-- --- Keymap Utilities --------------------------------------------------------

add {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        delay = 500,
        win = { border = "single" },
    },
}

add {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
    },
    keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
}

-- --- Motions -----------------------------------------------------------------

add {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
        {
            desc = "Character jump.",
            mode = { "n", "v" },
            "s",
            function()
                require("flash").jump()
            end,
        },
        {
            desc = "Remote character jump",
            mode = { "o" },
            "s",
            function()
                require("flash").remote()
            end,
        },
    },
    opts = {
        modes = {
            search = { enabled = false },
            char = { enabled = false },
        },
        prompt = {
            enabled = true,
            prefix = { { "&", "FlashPromptIcon" } },
        },
    },
}

-- --- Text Editing ------------------------------------------------------------

add {
    "echasnovski/mini.splitjoin",
    version = "*",
    opts = { mappings = { toggle = "gS", split = "", join = "" } },
    event = "VeryLazy",
}

vim.api.nvim_create_user_command("Column", function(args)
    if args.range ~= 2 then
        vim.notify(
            "The Column command works only in visual line mode.",
            vim.log.levels.WARN,
            {}
        )
        return
    end

    local line_start = args.line1 - 1
    local line_end = args.line2
    local content = vim.api.nvim_buf_get_lines(0, line_start, line_end, true)
    local string_content = table.concat(content, "\n")

    local in_sep = vim.fn.input { prompt = "Input Separator: " }
    local out_sep = vim.fn.input {
        prompt = "Output Separator: ",
        default = in_sep,
    }

    local cmd_out = vim.system({
        "column",
        "-s",
        in_sep,
        "-o",
        out_sep,
        "-t",
    }, { text = true, stdin = string_content }):wait()

    if cmd_out.code ~= 0 then
        local msg = cmd_out.stderr or ("exit code " .. cmd_out.code)
        vim.notify("Column failed: " .. msg, vim.log.levels.WARN)
        return
    end

    local res_content = vim.split(cmd_out.stdout, "\n", { trimempty = true })
    vim.api.nvim_buf_set_lines(0, line_start, line_end, true, res_content)
end, { range = true })

vim.keymap.set(
    "v",
    "gC",
    ":Column<CR>",
    { desc = "Send region to column command." }
)

-- --- Treesitter --------------------------------------------------------------

add {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require "configs.treesitter"
    end,
}

-- --- File explorer -----------------------------------------------------------

add {
    "mikavilpas/yazi.nvim",
    dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
    keys = {
        {
            "<Leader>.",
            mode = { "n", "v" },
            "<cmd>Yazi<CR>",
            desc = "Open yazi at the current file",
        },
        {
            "<Leader>e",
            "<cmd>Yazi cwd<CR>",
            desc = "Open the file manager in nvim's working directory",
        },
        {
            "<Leader>E",
            "<cmd>Yazi toggle<CR>",
            desc = "Resume the last yazi session",
        },
    },
    opts = {
        yazi_floating_window_border = "single",
        floating_window_scaling_factor = 0.8,
        keymaps = { change_working_directory = "<C-g>" },
        open_for_directories = true,
        highlight_groups = {
            hovered_buffer = {},
            hovered_buffer_in_same_directory = {},
        },
    },
    -- https://github.com/mikavilpas/yazi.nvim/issues/802
    init = function()
        -- vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end,
}

-- --- Picker Framework --------------------------------------------------------

add {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Because of vim.ui.select wrapper, fzf-lua needs to run on startup.
    lazy = false,
    keys = {
        { "<Leader>f/", ":FzfLua blines<CR>" },
        { "<Leader>/",  ":FzfLua blines<CR>" },
        { "<Leader>ff", ":FzfLua files<CR>" },
        { "<Leader>fw", ":FzfLua live_grep<CR>" },
        { "<Leader>fs", ":FzfLua treesitter<CR>" },
        { "<Leader>fh", ":FzfLua help_tags<CR>" },
        { "<Leader>fH", ":FzfLua highlights<CR>" },
        { "<Leader>fa", ":FzfLua builtin<CR>" },
        { "<Leader>fc", ":FzfLua zoxide<CR>" },
        { "<Leader>fo", ":FzfLua nvim_options<CR>" },
        { "<C-x>",      ":FzfLua nvim_options<CR>" },
        { "<Leader>jf", ":FzfLua buffers<CR>" },
        { "<Leader>fj", ":FzfLua buffers<CR>" },
        {
            "<Leader>f.",
            function()
                require("fzf-lua").files { cwd = "~/.config/nvim" }
            end,
        },
    },
    opts = {
        winopts = {
            title_pos = "center",
            title_flags = false,
            border = "single",
            backdrop = 100,
            preview = {
                title = false,
                border = "single",
                layout = "flex",
                horizontal = "right:50%",
                vertical = "down:50%",
            },
        },
        keymap = {
            fzf = {
                ["ctrl-l"] = "accept",
                ["ctrl-h"] = "abort",
                -- select all and then send them to the quickfix list
                ["ctrl-q"] = "select-all+accept",
            },
        },
        files = {
            cwd_prompt = false,
            follow = true,
            hidden = true,
            fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude '*.pdf' --exclude '*.png' --exclude '*.jpg']],
        },
        grep = {
            follow = true,
            hidden = true,
        },
    },
    config = function(_, opts)
        local fzf = require "fzf-lua"
        fzf.register_ui_select()
        fzf.setup(opts)
    end,
}

-- --- Markdown ----------------------------------------------------------------

add {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter" },
        { "nvim-tree/nvim-web-devicons" },
    },
    ft = { "markdown" },
    opts = {
        heading = {
            sign = false,
            atx = false,
            icons = {
                " ◉  ",
                " ○  ",
                " ◆  ",
                " ◇  ",
                " ✸  ",
                " ✿  ",
            },
        },
        bullet = {
            icons = { "󰧟" },
            ordered_icons = nil,
        },
        latex = { enabled = false },
        anti_conceal = { enabled = true },
        dash = { enabled = false },
        code = {
            sign = false,
            width = "block",
            left_pad = 1,
            right_pad = 1,
            language_pad = 1,
        },
    },
}

add {
    "TobinPalmer/pastify.nvim",
    ft = { "markdown", "typst" },
    opts = {
        opts = { local_path = "/assets/attachments/" },
        ft = { typst = '#image("$IMG$")' },
    },
}

-- requires `sudo pacman -S imagemagick`
add {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    lazy = true,
    opts = {
        backend = "kitty",        -- or "ueberzug" or "sixel"
        processor = "magick_cli", -- or "magick_rock"
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                only_render_image_at_cursor_mode = "popup", -- or "inline"
                floating_windows = false,                   -- if true, images will be rendered in floating markdown windows
                filetypes = { "markdown", "vimwiki" },      -- markdown extensions (ie. quarto) can go here
            },
            neorg = {
                enabled = true,
                filetypes = { "norg" },
            },
            typst = {
                enabled = false,
                filetypes = { "typst" },
            },
            html = {
                enabled = false,
            },
            css = {
                enabled = false,
            },
        },
        max_width = 80,
        -- max_height = 12,
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,
        scale_factor = 1.0,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = {
            "cmp_menu",
            "cmp_docs",
            "snacks_notif",
            "scrollview",
            "scrollview_sign",
        },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = {
            "*.png",
            "*.jpg",
            "*.jpeg",
            "*.gif",
            "*.webp",
            "*.avif",
        }, -- render image files as images when opened
    },
}

-- distro package deps: pynvim, jupyter_client;
-- sometimes needed to create the folder '~/.local/share/jupyter/runtime'
-- manually;
add {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    lazy = true,
    ft = {
        "markdown",
        "quarto",
        "org",
        "neorg",
    },
    keys = {
        {
            lleader "m",
            "",
            desc = "Molten",
        },
        {
            lleader "mi",
            cmd "MoltenInit",
            desc = "Molten: Init kernel",
        },
        {
            lleader "me",
            cmd "MoltenEvaluateOperator",
            desc = "Molten: Run operator selection",
        },
        {
            lleader "m.",
            cmd "MoltenEvaluateLine",
            desc = "Molten: Run current line",
        },
        {
            lleader "mr",
            cmd "MoltenReevaluateCell",
            desc = "Molten: Reevaluate cell",
        },
        {
            lleader "md",
            cmd "MoltenDelete",
            desc = "Molten: Delete current cell",
        },
        {
            lleader "mo",
            cmd "MoltenEnterOutput",
            desc = "Molten: Enter cell's output",
        },
        {
            mode = "v",
            lleader "me",
            ":<C-u>MoltenEvaluateVisual<CR>gv",
            desc = "Molten: Reevaluate cell",
        },
    },
    build = ":UpdateRemotePlugins",
    init = function()
        vim.g.molten_image_provider = "image.nvim"

        vim.g.molten_output_win_max_height = 20

        vim.g.molten_virt_text_output = true
        vim.g.molten_virt_text_max_lines = 20
    end,
}

-- --- Typst -------------------------------------------------------------------

add {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    keys = {
        {
            mode = "n",
            "<LocalLeader>s",
            ":TypstPreviewToggle<CR>",
            desc = "Toggle Typst SVG preview",
        },
        {
            mode = "n",
            "<LocalLeader>o",
            ":OpenPdf<CR>",
            desc = "Open file's pdf output",
        },
    },
    opts = { debug = true, port = 3030 },
}

-- --- Git ---------------------------------------------------------------------

add {
    "lewis6991/gitsigns.nvim",
    opts = {},
}

-- --- Building & Running ------------------------------------------------------

add {
    "stevearc/overseer.nvim",
    version = "v1.6.0",
    keys = {
        {
            desc = "Tasks",
            "<Leader>r",
            "",
        },
        {
            desc = "Tasks: Toggle window",
            "<Leader>ro",
            ":OverseerToggle!<CR>",
        },
        {
            desc = "Tasks: Run a task",
            "<Leader>rr",
            ":OverseerRun<CR>",
        },
        {
            desc = "Tasks: Restart last task",
            "<Leader>rl",
            ":OverseerRestartLastTask<CR>",
        },
        {
            desc = "Tasks: Run a raw shell command",
            "<Leader>rs",
            ":OverseerRunCmd<CR>",
        },
        {
            desc = "Tasks: Actions for current task",
            "<Leader>ra",
            ":OverseerTaskAction<CR>",
        },
    },
    opts = {
        templates = { "builtin" },
        task_list = {
            min_height = 7,
            min_width = 10,
            default_detail = 1,
            bindings = { ["q"] = "Close" },
        },
        form = { border = "single" },
        confirm = { border = "single" },
        task_win = { border = "single" },
        help_win = { border = "single" },
    },
    config = function(_, opts)
        local overseer = require "overseer"
        overseer.setup(opts)
        vim.api.nvim_create_user_command("OverseerRestartLastTask", function()
            local tasks = overseer.list_tasks()
            if vim.tbl_isempty(tasks) then
                vim.notify(
                    "Overseer: Can't restart last task, as there aren't any.",
                    vim.log.levels.WARN,
                    {}
                )
            else
                overseer.run_action(tasks[1], "restart")
            end
        end, {})

        overseer.register_template {
            name = "Watch PDF Compilation",
            builder = function()
                local filename = vim.fn.expand "%:p"
                return {
                    cmd = { "typst" },
                    args = { "watch", filename },
                    -- components = {
                    --     { "on_output_quickfix", open = true },
                    --     "default",
                    -- },
                }
            end,
            priority = 100,
            condition = { filetype = { "typst" } },
            tags = { overseer.TAG.BUILD },
        }

        overseer.register_template {
            name = "Live server in CWD",
            builder = function()
                return {
                    cmd = {
                        "/home/mrcapivaro/.local/share/cargo/bin/live-server",
                    },
                    -- components = {
                    --     { "on_output_quickfix", open = true },
                    --     "default",
                    -- },
                }
            end,
            priority = 100,
            condition = {
                filetype = {
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "typescriptreact",
                },
            },
            tags = { overseer.TAG.BUILD },
        }
    end,
}

-- --- LSP, Autocompletion & Snippets ------------------------------------------

add {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>im", ":Mason<CR>" } },
    opts = {
        -- ui = { border = "single" },
    },
}

add {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}

add {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPre", "BufNewFile" },
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "williamboman/mason.nvim",
        "folke/lazydev.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = function()
        require "configs.lsp"
    end,
}

add {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    event = "VeryLazy",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = { enable_autosnippets = true },
    config = function(_, opts)
        local ls = require "luasnip"
        ls.setup(opts)
        vim.tbl_map(function(element)
            require("luasnip.loaders.from_" .. element).lazy_load()
        end, {
            "vscode",
            "lua",
            -- "snipmate",
        })
        require "configs.luasnip"
    end,
}

add {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "folke/lazydev.nvim",
    },
    version = "1.*",
    opts = {
        snippets = { preset = "luasnip" },
        enabled = function()
            return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        end,
        completion = {
            menu = {
                auto_show = true,
                border = "single",
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                window = { border = "single" },
            },
        },
        signature = {
            enabled = true,
            window = { border = "single" },
        },
        keymap = {
            preset = "none",
            -- Main
            ["<C-.>"] = { "show", "hide", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-l>"] = { "select_and_accept", "fallback" },
            -- Docs
            ["<C-h>"] = {
                "hide_documentation",
                "show_documentation",
                "fallback",
            },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            -- Snippets
            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
        },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },
        cmdline = {
            keymap = { preset = "inherit" },
            completion = { menu = { auto_show = true } },
        },
    },
}

-- --- Web Development ---------------------------------------------------------

add {
    "norcalli/nvim-colorizer.lua",
    ft = {
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    config = function()
        require("colorizer").setup({ html = { names = false } }, { css = true })
    end,
}

-- --- Performance -------------------------------------------------------------

add {
    "https://github.com/LunarVim/bigfile.nvim",
    opts = {
        filesize = 2,
        features = {
            "indent_blankline",
            "illuminate",
            "lsp",
            "treesitter",
            "syntax",
            "matchparen",
            "vimopts",
            "filetype",
        },
    },
}

-- --- CSV ---------------------------------------------------------------------

add {
    "hat0uma/csvview.nvim",
    ft = "csv",
    opts = {},
    config = function(_, opts)
        require("csvview").setup(opts)
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = { "*.csv" },
            callback = function()
                vim.fn.execute "CsvViewEnable"
            end,
        })
        vim.keymap.set(
            "n",
            lleader "s",
            cmd "CsvViewToggle",
            { desc = "Toggle CSV view", buffer = true }
        )
    end,
}

-- == Plugin Setup =============================================================

require("lazy").setup(plugin_list, {
    -- ui = { border = "single" },
    defaults = { lazy = false },
    install = { colorscheme = { "habamax" } },
    performance = {
        rtp = {
            disabled_plugins = {
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",

                "gzip",
                "zip",
                "zipPlugin",
                "tar",
                "tarPlugin",

                "getscript",
                "getscriptPlugin",

                "vimball",
                "vimballPlugin",

                "2html_plugin",
                "logipat",
                "rrhelper",
                "spellfile_plugin",
                "matchit",
            },
        },
    },
})

-- =============================================================================
-- = Autocommands ==============================================================
-- =============================================================================

local user_augroup = vim.api.nvim_create_augroup("User", {})

-- Try to move to the last editing position when opening a recent buffer.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = user_augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto reload files on change.
vim.api.nvim_create_autocmd("BufEnter", {
    group = user_augroup,
    callback = function()
        vim.cmd "checktime"
    end,
})

-- =============================================================================
-- = Keymaps ===================================================================
-- =============================================================================

-- == Quality of Life  =========================================================

setmap {
    { non_insert, "<Leader>q", ":quitall!<CR>",   "Quit Neovim" },
    -- { non_insert, "<tab>", "za" },
    {
        all,
        "<esc>",
        "<cmd>noh<CR><esc>",
        "Escape and also clear hlsearch",
    },
    { non_insert, "<C-a>",     "ggVG" },
    { visual,     "<S-k>",     "<cmd>m+1<CR>vv" },
    { visual,     "<S-j>",     "<cmd>m-2<CR>vv" },
    { line,       "<S-k>",     ":m '<-2<CR>gv=gv" },
    { line,       "<S-j>",     ":m '>+1<CR>gv=gv" },
    { line,       ">",         ">gv" },
    { line,       "<",         "<gv" },
    { normal,     "<C-u>",     "<C-u>zz" },
    { normal,     "<C-d>",     "<C-d>zz" },
    { normal,     "n",         "nzz" },
    { normal,     "N",         "Nzz" },
    -- Macros
    { non_insert, "<C-q>",     "q" },
    { non_insert, "q",         "@" },
}

-- == Window Commands  =========================================================

local direction_keys = {
    -- stylua: ignore
    left  = "h",
    down  = "j",
    up    = "k",
    right = "l",
}

-- SmartResize = What resizing should actually be.
--
-- direction: "left", "down", "up" or "right"
-- amount: integer bigger than 0 and less than 90% of the window width.
--
-- ex:
-- Resize("left", 10)
-- Resize("up", 5)
local SmartResize = function(direction, amount)
    vim.cmd "windo > ."
end

setmap {
    { normal, "<Leader>w",  "",           "Window" },
    { normal, "<Leader>wd", "<C-w>q",     "Close current window" },
    { normal, "<Leader>w.", "<C-w><C-o>", "Close all other windows" },
    { normal, "<Leader>ws", "<C-w>s",     "Horizontal split" },
    { normal, "<Leader>wv", "<C-w>v",     "Vertical split" },
    { normal, "<Leader>wo", "<C-w>w",     "Go to last window" },
    { normal, "<Leader>wh", "<C-w>h",     "Move window focus left" },
    { normal, "<Leader>wj", "<C-w>j",     "Move window focus down" },
    { normal, "<Leader>wk", "<C-w>k",     "Move window focus up" },
    { normal, "<Leader>wl", "<C-w>l",     "Move window focus right" },
}

local setrmap = function(args)
    local mode = { args.mode }
    local base = args.base
    local maps = args.maps
    for _, rel in ipairs(maps) do
        local head = rel[1]
        local action = rel[2]
        setmap { { mode, base .. head, action .. base, opts = { remap = true } } }
    end
end

setrmap {
    mode = "n",
    base = leader "w",
    maps = {
        { "K", "<C-w>+" },
        { "J", "<C-w>-" },
        { "L", "<C-w>>" },
        { "H", "<C-w><" },
    },
}

-- == Marks  ===================================================================

setmap {
    { non_insert, "m", "`", "Move to mark." },
    { non_insert, "M", "m", "Create a mark." },
}

-- == Execution of code  =======================================================

setmap {
    { non_insert, "x",  "",         "Execute" },
    { non_insert, "xx", ":" },
    { non_insert, "xc", ":!" },
    { non_insert, "xl", ":<UP><CR>" },
}

-- == Surround Selection  ======================================================

setmap {
    { visual, "s<", "di<><Esc><Left>p", "Surround selection with <>" },
    { visual, "s>", "di<><Esc><Left>p", "Surround selection with <>" },
    { visual, "s{", "di{}<Esc><Left>p", "Surround selection with {}" },
    { visual, "s}", "di{}<Esc><Left>p", "Surround selection with {}" },
    { visual, "s[", "di[]<Esc><Left>p", "Surround selection with []" },
    { visual, "s]", "di[]<Esc><Left>p", "Surround selection with []" },
    { visual, "s(", "di()<Esc><Left>p", "Surround selection with ()" },
    { visual, "s)", "di()<Esc><Left>p", "Surround selection with ()" },
    { visual, "s'", "di''<Esc><Left>p", "Surround selection with ''" },
    { visual, 's"', 'di""<Esc><Left>p', 'Surround selection with ""' },
    { visual, "s ", "di  <Esc><Left>p", "Surround selection with spaces" },
}

-- == Buffers  =================================================================

local SmartBD = function(args)
    -- Get window and buffer info
    local winids = vim.api.nvim_list_wins()
    local listed_bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
            table.insert(listed_bufs, buf)
        end
    end
    local cbuf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_get_option_value(
        "filetype",
        { scope = "local", buf = cbuf }
    )

    -- Decide close command
    local close_cmd = args.force and "bd!" or "bd"

    -- Close buffer
    if #winids == 1 or ft == "help" then
        vim.cmd(close_cmd)
    elseif #winids > 1 then
        for _, winid in ipairs(winids) do
            if vim.api.nvim_win_get_buf(winid) == cbuf then
                vim.api.nvim_win_call(winid, function()
                    vim.cmd "bn"
                end)
            end
        end
        vim.cmd(close_cmd .. " #")
    end
end

setmap {
    {
        normal,
        "<Leader>,",
        ":b#<CR>",
        "Switch to last buffer",
    },
    { normal, "<Leader>j",  "",       "Buffers" },
    {
        normal,
        "<Leader>js",
        "<cmd>w<CR>",
        "Save current buffer",
    },
    {
        normal,
        "<Leader>jn",
        "<cmd>new<CR>",
        "Open a new buffer",
    },
    {
        normal,
        "<Leader>jd",
        function()
            SmartBD { force = false }
        end,
        "Close current buffer",
    },
    {
        normal,
        "<Leader>jD",
        function()
            SmartBD { force = true }
        end,
        "Force close current buffer",
    },
    { normal, "<Leader>jl", cmd "bn", "Next buffer" },
    { normal, "<Leader>jh", cmd "bp", "Previous buffer" },
    { normal, "L",          cmd "bn", "Next buffer" },
    { normal, "H",          cmd "bp", "Previous buffer" },
}

-- == Toggle Vim Options =======================================================

local toggle_option = function(option)
    return function()
        local opt = vim.wo[option] == true and ("no" .. option) or option
        local cmd = "setlocal " .. opt
        print(cmd)
        vim.cmd(cmd)
    end
end

setmap {
    { normal, "<Leader>t",  "",                   "Toggle" },
    { normal, "<Leader>tw", toggle_option "wrap", "Toggle text wrapping." },
    {
        normal,
        "<Leader>ts",
        toggle_option "list",
        "Toggle visual whitespaces.",
    },
    { normal, "<Leader>tn", toggle_option "number", "Toggle number column." },
}

-- == G Commands  ==============================================================

setmap {
    { normal, "ga", 'yiw:%s/<C-r>"//g<Left><Left>' },
    { visual, "ga", 'y:%s/<C-r>"//g<Left><Left>' },
}

-- == Quickfix  ================================================================

setmap {
    { normal, leader "c",  "",             "Quickfix" },
    { normal, leader "co", cmd "copen",    "Open qf list" },
    { normal, leader "cc", cmd "cclose",   "Close qf list" },
    { normal, leader "cl", cmd "cexpr []", "Clear qf list" },
}
