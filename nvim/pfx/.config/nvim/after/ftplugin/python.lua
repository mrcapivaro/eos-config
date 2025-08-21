local overseer = require("overseer")

overseer.register_template {
    name = "Run current script",
    builder = function()
        local filename = vim.fn.expand "%:p"
        return {
            cmd = { "python" },
            args = { "-u", "-W", "default", filename },
            -- components = {
            --     { "on_output_quickfix", open = true },
            --     "default",
            -- },
        }
    end,
    priority = 100,
    condition = { filetype = { "python" } },
    tags = { overseer.TAG.BUILD },
}

overseer.register_template {
    name = "Run current script interactively",
    builder = function()
        local filename = vim.fn.expand "%:p"
        return {
            cmd = { "python" },
            args = { "-i", "-u", "-W", "default", filename },
            -- components = {
            --     { "on_output_quickfix", open = true },
            --     "default",
            -- },
        }
    end,
    priority = 100,
    condition = { filetype = { "python" } },
    tags = { overseer.TAG.BUILD },
}
