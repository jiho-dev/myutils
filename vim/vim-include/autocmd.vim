""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType * set tabstop=4|set shiftwidth=4|set noexpandtab|set fo=tcq

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 마지막 편집 위치로 간다
autocmd BufReadPost *
   \ if line("'\"") > 0 && line("'\"") <= line("$") |
   \   exe "normal g`\"" |
   \   exe "normal zz" |
   \ endif

" c,cpp,h 파일은 tab을 space으로 변경
au Bufenter *.\(c\|cpp\|h\) set expandtab
autocmd FileType make setlocal noexpandtab 	" disable it for Makefile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PlantUML
" ~/.vim/syntax$ wget https://raw.githubusercontent.com/aklt/plantuml-syntax/master/syntax/plantuml.vim
" https://github.com/scrooloose/vim-slumlord
" https://github.com/weirongxu/plantuml-previewer.vim
autocmd BufRead,BufNewFile *.puml set filetype=plantuml
"au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
"    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
"    \  1,
"    \  0
"    \)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python: use white space instead of tab in Python
"autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
"autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql
autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=ql wrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" config file
autocmd BufEnter *.conf setf dosini set expandtab sw=4 ts=4
au BufEnter *.conf set expandtab

" auto comment 기능을 off 한다. /**/의 자동 생성
"au FileType *.c setl fo-=cro
"au FileType *.c setlocal comments-=://


" 라인끝의 whitespace를 red로 표시
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" comment 와 관련한 사항.
"autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://

" Makefile에서 '#'으로 시작되는 문장에서 indent가 없어 지는 현상 방지
"autocmd FileType * set cindent
"autocmd FileType make set cindent

"autocmd FileType * set cindent
"	    \ cinkeys-=0#

" 현재 디렉토리를 현재 열고 있는 문서의 디렉토리로 변경한다.
"if has("autocmd")
"	autocmd BufEnter * :cd %:p:h
"endif

" 단어 자동 완성 기능을 사용한다.
"autocmd VimEnter * call DoWordComplete()

" jQuery syntax
"au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
"au BufRead,BufNewFile *.js set filetype=javascript
