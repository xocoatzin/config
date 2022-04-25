require("indent_blankline").setup {
    space_char_blankline = " ",
    use_treesitter = true,
    show_current_context = true,
    context_patterns = {'.*'},
    show_first_indent_level = false,
    filetype_exclude = {},
    buftype_exclude = {'terminal'},
}
