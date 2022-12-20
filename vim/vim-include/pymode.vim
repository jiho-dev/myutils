""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
"

function! PymodeSetup()

	let g:pymode = 1
	"let g:pymode_rope = 1

	" Documentation
	let g:pymode_doc = 0
	let g:pymode_doc_key = 'K'

	"Linting
	"let g:pymode_lint = 1
	let g:pymode_lint = 0
	"
	"Values may be chosen from: `pylint`, `pep8`, `mccabe`, `pep257`, `pyflakes`.
	"let g:pymode_lint_checker = "pylint,pyflakes,pep8,mmcabe,pep257"
	let g:pymode_lint_checker = "pyflakes,pep8,mmcabe,pep257"
	" Auto check on save
	let g:pymode_lint_write = 1
	"let g:pymode_lint_message = 1

	" Support virtualenv
	let g:pymode_virtualenv = 1

	" Enable breakpoints plugin
	let g:pymode_breakpoint = 1
	let g:pymode_breakpoint_bind = '<leader>b'

	" syntax highlighting
	let g:pymode_syntax = 1
	let g:pymode_syntax_all = 1
	let g:pymode_syntax_indent_errors = g:pymode_syntax_all
	let g:pymode_syntax_space_errors = g:pymode_syntax_all
	let g:pymode_syntax_highlight_equal_operator = g:pymode_syntax_all

	" Don't autofold code
	let g:pymode_folding = 0

	"let g:pep8_ignore="E501,W601,W0611"
	"let g:pep8_ignore="E501,W0611"
	let g:pymode_lint_ignore="E501,W0611,E265,W0612,E266,E303,W602,E129,W0401"
	"let g:pymode_lint_ignore="E501,W0611,E265,E129,E266"

	"let g:pymode_options_max_line_length=80
	let g:pymode_options_max_line_length=0

	let g:pymode_trim_whitespaces = 1 

	let g:pymode_indent = 1
	let g:pymode_lint_on_fly     = 0

	let g:pymode_lint_sort = ['E', 'C', 'I']

	"let g:pymode_rope_goto_definition_bind = "<C-]>"

	" do not open document window
	set completeopt=menu
endfunction

"call PymodeSetup()
