" Commenting blocks of code. While in normal or visual mode, enter ',cc' to
" comment and ',cu' to uncomment a line or block
" This will add the comment after all whitespace at the start of the line, and
" will insert one space after the comment_leader
" When uncommenting, it will only remove one level of commenting and will
" preserve any leading spaces and remove exactly 1 space after the comment
" TODO PFAY - add an option for adding the trailing space
" Consider using the NERD Commenter or some other plugin instead
" http://www.vim.org/scripts/script.php?script_id=1218
autocmd BufRead,BufNewFile Makefile,*.conf let b:comment_leader = '#'
autocmd BufRead,BufNewFile *.cs       let b:comment_leader = '//'
autocmd BufRead,BufNewFile *.as       let b:comment_leader = '//'
autocmd BufRead,BufNewFile *.groovy       let b:comment_leader = '//'
autocmd FileType c,cpp,java,scala,php,javascript let b:comment_leader = '//'
autocmd FileType sh,ruby,python,puppet    let b:comment_leader = '#'
autocmd FileType conf,fstab           let b:comment_leader = '#'
autocmd FileType tex                  let b:comment_leader = '%'
autocmd FileType mail                 let b:comment_leader = '>'
autocmd FileType vim                  let b:comment_leader = '"'
autocmd FileType sql                  let b:comment_leader = '--'
" old version that adds it at the very start of the line
" noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
" noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
" if you don't want to add a trailing space - remove this space
" -----------------------------------------------------------------------------------------V
" Why does this have a leading : but others don't?
" noremap <silent> ,cc :CommentPreserve<CR> //THIS DOESN'T WORK AT ALL
" if you don't want to add a trailing space - remove this space
" -----------------------------------------------------------------------------------------V
noremap <silent> ,cc :<C-B>silent <C-E>s/^\(\s*\)/\1<C-R>=escape(b:comment_leader,'\/')<CR> /<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>\s\?/\1/e<CR>:nohlsearch<CR>

function! Comment()
  " noremap <silent> ,cc :<C-B>silent <C-E>s/^\(\s*\)/\1<C-R>=escape(b:comment_leader,'\/')<CR> /<CR>:nohlsearch<CR>
  :<C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>\s\?/\1/e<CR>
endfunction
command Comment :call Comment()
command CommentPreserve :call Preserve("Comment")

" removes trailing whitespace
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  " :call <command>()
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction"
command -nargs=1 Preserve :call Preserve(<f-args>)
