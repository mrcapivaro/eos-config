local string = string

-- =============================================================================
-- Local options

vim.cmd "setlocal wrap"
vim.cmd "setlocal nonumber"
vim.cmd "setlocal nolist"

-- =============================================================================
-- Local commands and keymaps

-- -----------------------------------------------------------------------------
-- TODO item

local toggle_checkbox = function()
    local current_line = vim.api.nvim_get_current_line()
    local final_line = nil
    if current_line:match "^%s*%- %[[ ]%]" then
        final_line = current_line:gsub("%[ %]", "[x]")
    elseif current_line:match "^%s*%- %[[xX]%]" then
        final_line = current_line:gsub("%[[xX]%]", "[ ]")
    else
        vim.notify("Not a valid todo item.", vim.log.levels.WARN)
        return
    end
    vim.api.nvim_set_current_line(final_line)
end

vim.keymap.set("n", "<LocalLeader>m", toggle_checkbox, { buffer = true })

-- -----------------------------------------------------------------------------
-- Paste command wrapper

vim.api.nvim_create_user_command("SmartPaste", function(args)
    local clipboard = vim.fn.getreg "+"

    if clipboard:match "^https?:.+%..+" then
        local name

        if args.range == 2 then
            vim.cmd 'normal! gv"+y'
            name = vim.fn.getreg "+"
            print(name)
        else
            name = "link"
        end

        if clipboard:match "\n$" then
            clipboard = string
                .format("[%s](%s", name, clipboard)
                :sub(1, #clipboard - 1) .. ")\n"
        else
            clipboard = string.format("[%s](%s)", name, clipboard)
        end

        vim.fn.setreg("+", clipboard)
    end

    if args.range == 2 then
        vim.cmd "normal! gvp"
    else
        vim.cmd "normal! p"
    end
end, { range = true })

vim.keymap.set(
    { "n", "v" },
    "p",
    ":SmartPaste<CR>",
    { buffer = true, silent = true }
)
