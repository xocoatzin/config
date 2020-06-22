"if exists("b:current_syntax")
  "finish
"endif

" Custom conceal
syntax match todoCheckbox "\[\ \]" conceal cchar=
syntax match todoCheckbox "\[x\]" conceal cchar=

"let b:current_syntax = "markdown"

hi def link todoCheckbox Markdown
hi Conceal guibg=NONE

setlocal conceallevel=1
