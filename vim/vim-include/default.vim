"""""""""""""""""""""""
"" set basic
"""""""""""""""""""""""

set exrc
set title
set history=100
set	showcmd
set showmode
set showmatch
set wrap
"set nowrap
set noignorecase
set nomesg
set noslowopen
set noterse
set number
"set nonumber
set nolinebreak
set ruler
set visualbell t_vb=
set cursorline

"set report=2
"set wrapmargin=3

" change current directory
set autochdir

"Backspace key won't move from current line
set backspace=indent,eol,start

" 명령어 실행시 자동 저장
set autowrite

"""""""""""""""""""""""""
"편집 기능 설정
"""""""""""""""""""""""""

"커서의 위치를 항상 보이게 함.
set ru

"완성중인 명령을 표시
set sc

"여러 가지 이동 동작시 줄의 시작으로 자동 이동
set sol

"""""""""""""""""""""""""
"검색 기능 설정
"""""""""""""""""""""""""

"검색어 강조 기능
set hls

"검색시 파일 끝에서 처음으로 되돌리기 안함
"set nows

"검색시 대소문자를 구별하지 않음
set ic

"똑똑한 대소문자 구별 기능 사용
set scs

" tab menu off
set showtabline=0

" 윈도우 생성 옵션
set splitbelow
set splitright

"""""""""""""""""""""""""
" 기타
"""""""""""""""""""""""""
syntax on

" 마우스 사용을 활성화 한다.
"set mouse=an
" disable double-click
":map <2-LeftMouse> <Nop>
":map! <2-LeftMouse> <Nop>


" disable autofold
set nofoldenable


"""""""""""""""""""""""""
" debugging
"set verbosefile=~/.vim/verbose.log
"set verbose=100
