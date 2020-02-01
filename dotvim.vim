filetype on
filetype plugin on
set incsearch
set list
set listchars=tab:>-,trail:~,extends:<,precedes:>
set nocp                            "vim no-compativility mode
set ts=2                            "tab stop 2
set shiftwidth=2                    "tab shift width 2
set autoindent                      "use auto indenting
set smartindent                     "use smart indenting
set cindent                       "use c-style indenting
set cinoptions=m1,t0                "m1 makes it so a closing paren lines up with the line it was left open on
"t0 makes it so a function type declaration on the line before the function()
"name is NOT indented - I was getting false positives for this
"I might also like p0 for cinoptions but I haven't seen it be necessary

" set cinkeys="0{"
"set cinkeys="0{,0},0),:,0#,!^F,o,O,e"    "this is the default
set pastetoggle=<f5>
set expandtab                       "convert tabs to spaces
"autocmd FileType as set noexpandtab                       "convert tabs to spaces
set bs=2                            "allow backspace in insert mode
syntax enable                       "enable syntax highlighting
set ruler                           "use the ruler thigy
set showmatch                       "blink matching parentheses
set nobackup                        "don't do the ~ backups
set ignorecase                      "do case insensitive searching
set hls                             "use highlight search
set wmh=0                           "minimum windows height for splits
set smarttab
set visualbell
set smartcase
set title
set tabstop=2
set softtabstop=2
set viminfo='20,\"1000              "set vim register size between files (copy paste buffer) to 1000 lines
set shell=bash
set shellcmdflag=-c
" set shellcmdflag=-ic                "set vim to use the interactive shell so that the bashrc is used and aliases
" set shellcmdflag=-                "set vim to use the interactive shell so that the bashrc is used and aliases
                                    "are available when running commands through :!command

"set color scheme
" For iterm2, you'll want to check this out locally in non-hidden location and import a color scheme https://github.com/chriskempson/base16-iterm2
" set background=dark
" colorscheme base16-monokai

"after writing a php or json file - lint it (:w saves and syntax checks in php and json)
" au BufWritePost *.php !php -l %
au BufWritePost *.php !hhvm -l %
au BufWritePost *.json !cat % | python -m json.tool

" http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Should search for what you have selected - but seems to actually do the
" PREVIOUS search in practice for me
" vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'
" this one does current not previous, but doesn't handle slashes
vnoremap // y/\V<C-R>"<CR>

" map leader character to ',' (easier to type than '\')
let mapleader = ","

" run file with Python interpreter (,p)
:autocmd BufNewFile,BufRead *.py noremap <leader>p :w!<CR>:!python3 %<CR>

" run file with PHP interpreter (,p)
:autocmd FileType php noremap <leader>p :w!<CR>:!php %<CR>

" PHP parser check (,l)
" :autocmd FileType php noremap <leader>l :!php -l %<CR>
:autocmd FileType php noremap <leader>l :!hhvm -l %<CR>

" PHPUnit Test executers
" Run unit test on current function (,tt) (test test)
:autocmd BufNewFile,BufRead *.php noremap <leader>tt :TestFunc<CR>
" Run unit test on current class (,ta) (test all)
:autocmd BufNewFile,BufRead *.php noremap <leader>ta :Test<CR>
" Open unit test logs (,tl) (test log)
:autocmd BufNewFile,BufRead *.php noremap <leader>tl :TestLog<CR>

" Hacklang shortcuts
" Run hh_client --lint on current file (,hl)
:noremap <leader>hl :HHLint<CR>
" Run hack_format on current file (,hf) Defined hhvm/vim-hack bundle https://github.com/hhvm/vim-hack/blob/master/doc/hack.txt
" :noremap <leader>hf :HackFormat<CR>

command HHLint execute ":!hh_client --lint"

" Spit out a github link to the current line in the current file
:noremap <leader>gg :Github<CR>

" Runs the current file as a unit test (assumes it IS a unit test)
let phpUnitPath = "~/vendor/bin/phpunit" " TODO MAKE THIS YOUR PHP UNIT PATH
let phpUnitArgs = "--verbose --colors"
command TestFunc execute "! " . phpUnitPath . " " . phpUnitArgs . " --filter=" . ShowFuncName() . " %"

" Runs the current file as a unit test (assumes it IS a unit test)
command Test execute ":! " . phpUnitPath . " " . phpUnitArgs . " %"

" Opens the test logs. Quit the test log buffer with :bw
command TestLog execute ":edit ~/tmp/php.log" " TODO MAKE THIS YOUR PHP UNIT LOG PATH

" TListToggle (,t) (this is broken
" :noremap <leader>t :TlistToggle<CR>

command Github :set shellcmdflag=-ic | :execute "! github % " . line('.') | :set shellcmdflag=-c

" --------------------
" taglist settings
" -------------------
"
" search recursively upward for ctags file.
set tags=tags;/
" close all folds except for current file
let Tlist_File_Fold_Auto_Close = 1
" make tlist pane active when opened
let Tlist_GainFocus_On_ToggleOpen = 1
" width of window
let Tlist_WinWidth = 40
" close tlist when a selection is made, or when it's the last window open
let Tlist_Close_On_Select = 1
let Tlist_Exit_OnlyWindow = 1
" flags for different file types
let tlist_php_settings = 'php;c:class;f:function;d:constant'
let tlist_sql_settings = 'sql;P:package;t:table'
let tlist_ant_settings = 'ant;p:Project;r:Property;t:Target'


"variable tab completion
function InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" PHP parser check (CTRL-L)
" :autocmd FileType php noremap <C-L> :!/usr/bin/php -l %<CR>
:autocmd FileType php noremap <C-L> :!/usr/bin/hhvm -l %<CR>

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

" Custom Functions
" TODO PFAY THIS IS BUSETED
function! AckFunction(searchString)
  let searchString=a:searchString
  :!echo <searchString>
  "!ack a:searchString
endfunction

" Custom Commands
command -nargs=1 Ack :call AckFunction(<f-args>) " TODO PFAY THIS DOESN'T WORK RIGHT
" command -nargs=1 Acki :!bash -c "acki <args>"
command -nargs=1 Acki :set shellcmdflag=-ic | :execute '!echo acki <args>; acki <args>' | :set shellcmdflag=-c
"
" These are named for the lint error they fix - the starting bad state
command LintNoSpaceAfterComma :%s/,\(\S\)/, \1/gc
command LintSpaceBeforeComma :%s/\s\+,/,/gc
command LintExtraSpacesAfterComma :%s/,\(\s\)\{2,}/, /gc
command LintNoSpaceAfterCast :%s/(\(\(int\|bool\|float\|string\|array\|object\)\))\(\S\)/(\1) \3/gc
" This command runs all the above lint commands - if you add a new one please
" add it to the function as well
function LintAll()
  :LintNoSpaceAfterComma
  :LintSpaceBeforeComma
  :LintExtraSpacesAfterComma
  :LintNoSpaceAfterCast
endfunction
command LintAll :call LintAll()

" http://stackoverflow.com/questions/13634826/vim-show-function-name-in-status-line
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  ?\v^\s*(private|protected|public)\?\s*function\s*\zs([^\(]*)\ze\(?
  let lineText = getline(".")
  " http://stackoverflow.com/questions/3135322/regex-in-vimscript
  let funcName = matchstr(lineText, '\v^\s*(private|protected|public)?\s*function\s*\zs([^\(]*)\ze\(')
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
  return funcName
endfun
command ShowFuncName :call ShowFuncName()

function Dos2Unix()
  update
  e ++ff=dos
  setlocal ff=unix
  w
endfunction
command Dos2Unix :call Dos2Unix()

function Unix2Dos()
  update
  e ++ff=unix
  setlocal ff=dos
  w
endfunction
command Unix2Dos :call Unix2Dos()

" Remember last position in file
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif
"
" Install vundle if not already installed
if has("user_commands")
  " Setting up Vundle - the vim plugin bundler
  let VundleInstalled=0
  let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
  if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let VundleInstalled=1
  endif
endif
"
