" view pdf as text
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -

autocmd BufNewFile,BufRead *.sxml set filetype=scheme
autocmd BufNewFile,BufRead *.sil set filetype=tex
autocmd BufNewFile,BufRead *.lco set filetype=tex
autocmd BufNewFile,BufRead *.do set filetype=sh
autocmd BufNewFile,BufRead .envrc set filetype=bash
autocmd BufNewFile,BufRead flake.lock set filetype=json

autocmd FileType markdown,gitcommit setlocal spell
autocmd FileType markdown setlocal iskeyword+=-

" see help restore-cursor
autocmd BufRead * autocmd FileType <buffer> ++once
     \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

" https://jdhao.github.io/2020/05/22/highlight_yank_region_nvim/
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END
