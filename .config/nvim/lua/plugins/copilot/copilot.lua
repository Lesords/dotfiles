require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        debounce = 50,
        keymap = {
            accept = "<c-a>",
            accept_word = "<M-f>",
            accept_line = "<C-e>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<c-]>",
        },
    },
    should_attach = function(_, bufname)
        if string.match(bufname, "codecompanion") then
            return false
        end
        return true
    end,
})
