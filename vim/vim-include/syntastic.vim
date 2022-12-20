""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for syntastic 

function! SyntasticSetup()
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	" enable/disable syntastic: SyntasticToggleMode<CR>
	" run syntastic: SyntasticCheck<CR>
	" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
	" for GO
	"let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']
	let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']

	let g:syntastic_python_checkers = ['pylint']
	"let g:syntastic_python_checkers = ['flake8']

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 0
	let g:syntastic_check_on_wq = 0
	let g:syntastic_loc_list_height=5

	" close error window: SyntasticReset

	"let g:syntastic_quiet_messages = {'level': 'warning'}
	"let g:syntastic_enable_signs = 1
	let g:syntastic_enable_highlighting = 0
	let g:syntastic_python_pylint_args = '--disable=C0111,R0903,R0201,C0103,C0325,W0611,R0902,R0913,E0704,C0301,R0204,R0914,W0703,E1121,W0511,C0330,W0613,R0904,R0912,E1136,W0612,W0107'
	"let g:syntastic_python_pylint_args_after = '-f text --msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} {msg_id}" -r n'
	"
endfunction

"call SyntasticSetup()
