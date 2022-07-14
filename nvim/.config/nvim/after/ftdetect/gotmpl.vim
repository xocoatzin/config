augroup filetypedetect
autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
augroup END
