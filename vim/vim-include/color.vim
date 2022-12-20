""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" setup terminal encoding
set termencoding=utf-8

""""""""""""""""
"  xterm-256
""""""""""""""""
" set t_Co=256
set t_Co=16

"if has("terminfo")
	"set t_Co=8
	"set t_Sf=^[[3%p1%dm
	"set t_Sb=^[[4%p1%dm
"else
	"set t_Co=8
	"set t_Sf=^[[3%dm
	"set t_Sb=^[[4%dm
"endif

"============================"
" Color Code Table
"============================"
" 0		Black
" 1		Dark Red
" 2		Drak Green
" 3		Yellow
" 4		Dark Blue
" 5		Dark Magenta
" 6 	Dark Cyan
" 7		White

"============================"
"*cterm-colors*

"NR-16   NR-8    COLOR NAME
"0       0       Black
"1       4       DarkBlue
"2       2       DarkGreen
"3       6       DarkCyan
"4       1       DarkRed
"5       5       DarkMagenta
"6       3       Brown, DarkYellow
"7       7       LightGray, LightGrey, Gray, Grey
"8       0*      DarkGray, DarkGrey
"9       4*      Blue, LightBlue
"10      2*      Green, LightGreen
"11      6*      Cyan, LightCyan
"12      1*      Red, LightRed
"13      5*      Magenta, LightMagenta
"14      3*      Yellow, LightYellow
"15      7*      White


function! MyColor()
	"일반적인 문자에 적용 된다.
	"hi Normal ctermbg=DarkGrey ctermfg=White guifg=White guibg=grey20
	"hi Normal ctermbg=DarkGrey ctermfg=Gray guifg=Gray guibg=Black

	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"	Normal Tag
	"
	highlight   Search 		ctermfg=0 ctermbg=7 
	highlight	Comment		ctermfg=6
	"highlight	Include		ctermfg=6 cterm=bold
	"highlight	Statement	ctermfg=3
	"highlight	String		ctermfg=3
	"highlight	Type		ctermfg=2
	"highlight	Function	cterm=bold
	"highlight	Error		ctermfg=1 cterm=bold
	"highlight	PreCondit	ctermfg=6 cterm=bold
	"

	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" 현재 라인을 표시한다.
	"highlight ActiveJob ctermfg=black ctermbg=white
	"hi LineNr term=underline ctermfg=DarkYellow guifg=Yellow
	hi LineNr ctermfg=DarkYellow guifg=Yellow
	"hi CursorLineNr term=underline cterm=underline ctermfg=DarkYellow gui=underline guifg=Yellow
	hi CursorLineNr term=reverse cterm=reverse ctermfg=DarkYellow gui=reverse guifg=Yellow
	hi CursorLine term=NONE cterm=NONE 

	hi WarningMsg term=standout ctermfg=LightRed guifg=Red

	" (), {} 매치
	"hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
	hi MatchParen cterm=NONE ctermbg=red ctermfg=white

	"highlight BadWhitespace ctermbg=red guibg=#d70000

	" for GO
	hi goDiagnosticError ctermbg=5 ctermfg=7*
	hi goDiagnosticWarning ctermbg=7 ctermfg=0

endfunction

function! MakefileColor()
	"	Makefile
	"
	highlight   makeSpecial ctermfg=1 cterm=NONE
	highlight   makeTarget  ctermfg=1 cterm=NONE
	highlight   makeIdent   ctermfg=4 cterm=NONE
	highlight   makeEscapedChar ctermfg=1 cterm=NONE
endfunction

function! CColor()
	"	C programming Color definition
	"
	highlight	cComment	ctermfg=6
	highlight	cType		ctermfg=2
	"highlight	cppType		ctermfg=3
	"highlight	cppClassDecl	ctermfg=2
	"highlight	cppClassPreDecl	ctermfg=2
	highlight	cStructure	ctermfg=2
	highlight	cStorageClass	ctermfg=2
	"highlight	cFunction	ctermfg=7
	"highlight	cppFunction	ctermfg=7
	"highlight	cppStatement	ctermfg=2
	"highlight	cppMethod	ctermfg=7

	"highlight	cString		ctermfg=5
	highlight	cString		ctermfg=red
	highlight	cNumber		ctermfg=red
	highlight	cConstant	ctermfg=red
	"highlight	cCharacter	ctermfg=7
	"highlight	cSpecial	ctermfg=7
	highlight	cSpecial	ctermfg=Magenta

	"""""
	highlight	cText		ctermfg=Gray
	highlight	cStatement	ctermfg=Gray
	"highlight	cCharacter	ctermfg=Gray
	"""""

	highlight	cLabel		ctermfg=2
	"highlight	cLabel		ctermfg=Green
	highlight	cUserLabel	ctermfg=2
	highlight	cUserCont	ctermfg=2
	highlight	cConditional	ctermfg=2
	highlight	cRepeat		ctermfg=2
	highlight	cStatement	ctermfg=2
	highlight	cOperator	ctermfg=2
	highlight	cError		ctermfg=2

	"highlight	cCommentError	ctermfg=7
	highlight	cInclude	ctermfg=2
	"highlight	cIncluded	ctermfg=4
	"highlight	cPreProc	ctermfg=7
	"highlight	cPreCondit	ctermfg=1
	"highlight	cDefine		ctermfg=orange
endfunction

function! HtmlColor()
	"
	"	HTML
	"
	"highlight	htmlStatement	ctermfg=3
	"highlight	htmlValue	ctermfg=6
	"highlight	htmlString	ctermfg=6

	"highlight link htmlFunction   ctermfg=3
	"highlight htmlTag    ctermfg=3
	"highlight link htmlFuncDef    ctermfg=3
	"highlight link htmlArg    Type
	"highlight link htmlTagName    htmlStatement
	"highlight link htmlValue  Value
	"highlight link htmlSpecialChar Special
	"highlight link htmlSpecial    Special
	"highlight link htmlSpecialChar    Special
	"highlight link htmlString     String
	"highlight link htmlCharacter  Character
	"highlight link htmlSpecialCharacter   htmlValue
	"highlight link htmlNumber     Number
	"highlight link htmlStatement  Statement
	"highlight link htmlComment    Comment
	"highlight link htmlPreProc    PreProc
	"highlight link htmlType   Type
	"highlight link htmlValue  String
endfunction

function! JavaColor()
	"	Java
	"
	"highlight javaComment    ctermfg=2
	"highlight javaExternal    ctermfg=6
	"highlight javaConditional    ctermfg=2
	"highlight javaRepeat    ctermfg=2
	highlight javaExceptions    ctermfg=1
	highlight javaClassDecl    ctermfg=3

	highlight javaType    ctermfg=7
	highlight javaOperator    ctermfg=7

	highlight javaBraces    ctermfg=3
	highlight javaFuncDef    ctermfg=3
	highlight javaString    ctermfg=7

	highlight javaClassDef	ctermfg=3

endfunction

function! DiffColor()
	" for vimdiff
	" cterm - sets the style
	" ctermfg - set the text color
	" ctermbg - set the highlighting
	" DiffAdd - line was added
	" DiffDelete - line was removed
	" DiffChange - part of the line was changed (highlights the whole line)
	" DiffText - the exact part of the line that changed

	"highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
	"highlight DiffAdd cterm=none ctermfg=White ctermbg=Green gui=none guifg=bg guibg=Green
	"highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
	"highlight DiffDelete cterm=none ctermfg=bg ctermbg=White gui=none guifg=bg guibg=White
	"highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
	"highlight DiffChange cterm=none ctermfg=White ctermbg=Yellow gui=none guifg=bg guibg=Yellow
	"highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta
	"highlight DiffText cterm=none ctermfg=White ctermbg=Magenta gui=none guifg=bg guibg=Magenta
endfunction

function! CustomColorVim90()
	hi Normal ctermfg=cyan ctermbg=NONE cterm=NONE
	hi EndOfBuffer ctermfg=yellow ctermbg=NONE cterm=NONE
	hi Terminal ctermfg=cyan ctermbg=NONE cterm=NONE
endfunction

augroup MyCustomColors
    autocmd!
    autocmd ColorScheme * call MyColor()
    autocmd ColorScheme * call MakefileColor()
    autocmd ColorScheme * call CColor()

	"autocmd ColorScheme * call CustomColorVim90()
    "autocmd ColorScheme * call HtmlColor()
    "autocmd ColorScheme * call JavaColor()
    "autocmd ColorScheme * call DiffColor()
augroup END

colorschem ron-jiho
