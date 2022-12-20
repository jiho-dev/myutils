
set autoindent
set smartindent

"set cindent


" tab을 space으로 변경
"set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4 " makes the spaces feel like real tabs

"""""""""""""""""""""
"붙여 넣기시 계단현상 제거(http://demo.initech.com/?document_srl=9718)
"set paste!

"""""""""""""""""""""
" { 의 위치 지정
" help cinoptions-values
" vim default values
"cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us, \U0,w0,m0,j0,)20,*30
"set cino=e1

"""""""""""""""""""""
" 091030 현재 사용중.
" {}의 위치가 복합적으로 사용 되는 경우 불편하다.
"set cino={1s,:0,(0
"set cino=\:0,:0,(0
"set cino=:0,(0,c0,l1
"set cino=(0,c0,l1 " switch-case 정렬 방법 변경.
set cino=(0,c0,:0 " switch-case 정렬 방법 변경.
