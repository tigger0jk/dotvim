" We're treating any javascript as javascriptreact
" This kind of works for our purposes but can mess some stuff up in the future
autocmd BufNewFile,BufRead *.js noautocmd set filetype=javascriptreact
