""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  function key mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"map 	<2-LeftMouse> <NOP>
"map 	<RightMouse> <NOP>
"map 	<2-RightMouse> <NOP>

" 함수 help
"map 	<F1> 	K
"imap 	<F1> 	<C-O>K
map 	<F1> 	<NOP>
imap 	<F1> 	<NOP>

" 파일 저장
map 	<F2> 	:w!<CR>
imap 	<F2> 	<C-O>:w!<CR>

" Run make
map 	<F3> 	:call DoMake()<CR>
imap 	<F3> 	<C-O>:call DoMake()<CR>
"map 	<F3> 	:make!<CR>
"imap 	<F3> 	<C-O>:make!<CR>

map 	<F4>	:make! custom<CR>
imap 	<F4> 	<C-O>:make! custom<CR>

" F4 to toggle paste mode
map 	<F5> :set invpaste<CR>
set pastetoggle=<F5>

"map 	<F5> 	:25vs ./<CR>
"map 	<F5> 	:make! tag<CR>
"imap 	<F5> 	<C-O>:make! tag<CR>

" function prototype
map 	<F6> 	[i

" 폴더 창 이동
"map 	<F6> 	w

" 선택된 파일 열기
"map 	<F7> 	O

"
"map 	<F8>
map		<F8>	:call ToggleVimGoDiagnostics() <CR>
imap	<F8>	<C-O>:call ToggleVimGoDiagnostics() <CR>

" 무조건 종료
"map 	<F9> 	:q!<CR>
"imap 	<F9> 	<C-O>:q!<CR>

map 	<F9> 	:GoRename 
imap 	<F9> 	<C-O>:GoRename 

" [중요] : screen에서 사용하기 위해 F10~F12는 남겨 놓는다.
" 정의는 .screenrc에 있음.
"map 	<F10>
"map 	<F11>
"map 	<F12>

" {{{ }}}
"nmap 	<F9> 	[{v]}zf
" folding
"nmap 	<F11> 	v]}zf
" folding 복구
"nmap 	<F12> 	zo

" Vertical Window Movement
" Move left window
"map <F9> 	<C-W>H
" Move right window
"ap <F12> 	<C-W>L
" Move up window
"ap <F10> 	<C-W>K
" Move donw window
"ap <F11> 	<C-W>J

"map J 	<C-W>H
"map K 	<C-W>L
"map I 	<C-W>K
"map M 	<C-W>J

"map <F7> 	<C-O>
"map <F8> 	<C-I>

"map <F9>    :IndexerRebuild<CR>
"imap <F9>   :IndexerRebuild<CR>

"map <F9>    :call MakeDoxygenComment()<CR>
"map <F10> 	:call InsertFileDesc()<CR>
"map <F11> 	:call InsertHeaderFileDesc()<CR>
"map <F12> 	:call InsertExcludeTag()<CR>
"map <F12> 	:NERDTreeToggle<CR>
"map <F12> 	:call RemoveVimSwapFile()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" normal key mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" copy to clipboard file
"map 	<C-C> 	:w! ~/.vimbuf<CR>
"map 	<C-C> 	y:tabnew<CR>p1Gdd:w! ~/.vimbuf<CR>:q!<CR>
map 	<silent> <C-C> 	:call CopyToBuf()<CR>

" paste to current line from clipboard file
"map 	<C-V> 	:r ~/.vimbuf<CR>
"imap 	<C-V> 	<C-O>:r ~/.vimbuf<CR>
"map 	<C-V> 	:tabnew<CR>:r ~/.vimbuf<CR>1GddyG:tabn<CR>p:tabn<CR>:q!<CR>
"imap 	<C-V> 	<ESC>:tabnew<CR>:r ~/.vimbuf<CR>1GddyG:tabn<CR>p:tabn<CR>:q!<CR>
map 	<C-V> 	:call PasteFromBuf()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 화면이동 키를 리맵한다.
map 	<C-j> 	<C-E>
imap 	<C-j> 	<C-O><C-E>
map 	<C-k> 	<C-Y>
imap 	<C-k> 	<C-O><C-Y>

map 	f 		<C-f> 	
map 	b 		<C-b> 	

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 함수가 여러개 있는 경우 선택 가능하게 한다.
"map		<C-->	g]
"map		<C-\>	g]
"map 	<C-p> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" 화면에 highligt를 반전한다.
"map 	<C-I> 	:set invhls<CR>

map 	<C-o> 	:e 
"map 	<C-p> 	<Nop>

" disable increase number
nmap    <C-A> 	<Nop>
" disable decrease number
nmap    <C-X> 	<Nop>


"""""""""""""""""""""""""""""""""""""""""""""""
"" for normal key 

" C souce commnet
noremap <silent> ,c :call CommentLine()<CR>
noremap <silent> ,u :call UnCommentLine()<CR>

" 변경내용을 무시하고 무조건 vim을 종료 
noremap <silent> Q :q!<CR>

" grep for word under cursor in c/cpp/h-files 
"map 	,g 	:grep! --color=auto --exclude=tags --exclude=cscope.out -I <cword> *.[ch]   <cr> :cw<CR>
map 	,g 	:grep! --color=auto --exclude=tags --exclude=cscope.out -I <cword> *   <cr> :cw<CR>
map 	,G 	:grep! --exclude=tags --exclude=cscope.out --exclude-dir="linux_*" --exclude-dir=".svn"  -I <cword> * -r<cr> :cw<CR>

" 해당 파일의 함수 리스트를 보여준다.
"noremap ,t 	:TlistToggle<CR>

" close error window
"nnoremap ,e :call MyToggleQuickFix()<CR>
nnoremap ,e :call ToggleQuickfixList()<CR>
nnoremap ,s :call ToggleErrors()<CR>
"noremap ,e 	:cw<CR>
" close error window
"noremap ,w 	:ccl<CR>

" fileformat를 unix로 바꾼다. CR/LF가 있을 경우 unix형으로 하면 CR 이 없어진다.
noremap ,m 	:set ff=unix<CR>

" 현재 커서 위치의 문자를 변경한다.
nmap 	,r 	:%s/\<<c-r><c-w>\>/
" / / coloring이 이상해져서 넣었음...

" 함수 설명을 추가한다.
"noremap ,h 	:call InsertDesc()<CR>
"noremap ,h  :call MakeDoxygenComment()<CR>

" 이름과 날짜를 추가한다.
noremap ,n 	:call InsertName()<CR>

" 현재의 {}를 formatting 한다.
noremap	,f		=a{''	

" 현재 word를 대문자로 변환
noremap	,u 		gUiw

" 파일 전체 formatting
" gg=G
"
" set paste
" set nopaste

" 현재의 위치에서 바로 상위 {}를 찾는다.
noremap {		[{

" 현재의 위치에서 바로 아래 {}를 찾는다.
noremap }		]}

" 라인의 처음으로 이동한다.
noremap `		0
" 라인의 맨끝으로 이동한다.
noremap 0		$

"현재의 블럭을 좌indent 한다.
noremap ,<	<a{

"현재의 블럭을 우indent 한다.
noremap ,>	>a{

" mark에 관한 키 설정
map .m :call ToggleMarkWok()<cr>
map .c :call KillAllMarksWok()<cr>
map .p :call PrevMarkWok()<cr>
map .n :call NextMarkWok()<cr>
"nnoremap <silent> <leader>ff :call g:Jsbeautify()<cr>
"map .f :call g:Jsbeautify()<cr>

" command key
noremap ; :

" 먼지 잘모르겠음...
"map f :s/^/\/\//g
"map F :s/^/\/\//g
"map t :s/^/\t//g
"map T :s/^\t//g

