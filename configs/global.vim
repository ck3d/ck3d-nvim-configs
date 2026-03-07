" view pdf as text
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -

autocmd BufNewFile,BufRead *.sxml set filetype=scheme
autocmd BufNewFile,BufRead *.do set filetype=sh
autocmd BufNewFile,BufRead .envrc set filetype=bash
autocmd BufNewFile,BufRead *.typst set filetype=typst
autocmd BufNewFile,BufRead *.ncl set filetype=nickel

autocmd FileType markdown,gitcommit,typst,latex setlocal spell
autocmd FileType markdown setlocal iskeyword+=-

" see help restore-cursor
augroup RestoreCursor
  autocmd!
  autocmd BufReadPre * autocmd FileType <buffer> ++once
    \ let s:line = line("'\"")
    \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

" see help lua-highlight
au TextYankPost * silent! lua vim.highlight.on_yank()
