" view pdf as text
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -

autocmd BufNewFile,BufRead *.sxml set filetype=scheme
autocmd BufNewFile,BufRead *.sil set filetype=tex
autocmd BufNewFile,BufRead *.lco set filetype=tex
autocmd BufNewFile,BufRead *.do set filetype=sh
autocmd BufNewFile,BufRead *.jq set filetype=jq
autocmd BufNewFile,BufRead .envrc set filetype=bash
autocmd BufNewFile,BufRead flake.lock set filetype=json

autocmd FileType markdown,gitcommit setlocal spell
autocmd FileType markdown setlocal iskeyword+=-

" see help restore-cursor
autocmd BufRead * autocmd FileType <buffer> ++once
     \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

" see help lua-highlight
au TextYankPost * silent! lua vim.highlight.on_yank()
