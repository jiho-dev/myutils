""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for GO
" :GoInstallBinaries
" :GoUpdateBinaries
function! VimGoSetup()
  "set updatetime=100
  "set re=1
  "set nocursorcolumn
  "set ttyfast
  "set lazyredraw


  "syntax sync minlines=256
 
  "let mapleader = ","

  " vim-go related mappings
  "au FileType go nmap <Leader>r <Plug>(go-run)
  "au FileType go nmap <Leader>b <Plug>(go-build)
  "au FileType go nmap <Leader>t <Plug>(go-test)
  "au FileType go nmap <Leader>i <Plug>(go-info)
  "au FileType go nmap <Leader>s <Plug>(go-implements)
  "au FileType go nmap ,i <Plug>(go-implements)
  "au FileType go nmap <C-p> <Plug>(go-implements)
  "au FileType go nmap <Leader>c <Plug>(go-coverage)
  "au FileType go nmap <Leader>e <Plug>(go-rename)
  "au FileType go nmap <Leader>gi <Plug>(go-imports)
  "au FileType go nmap <Leader>gI <Plug>(go-install)
  "au FileType go nmap <Leader>gd <Plug>(go-doc)
  "au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  "au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
  "au FileType go nmap <Leader>ds <Plug>(go-def-split)
  "au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  "au FileType go nmap <Leader>dt <Plug>(go-def-tab)

  let g:go_list_type = "quickfix"
  let g:go_addtags_transform = "camelcase"
  "let g:go_autodetect_gopath = 1
  "let g:go_auto_sameids = 1
  ""let g:go_auto_type_info = 1

  " Use new vim 8.2 popup windows for Go Doc
  let g:go_doc_popup_window = 1

  "let g:go_fmt_command = "gofmt"
  "let g:go_fmt_command = "goimports"
  
  " auto import, default enabled
  "let g:go_fmt_autosave = 0

  let g:go_fmt_experimental = 1
  let g:go_dispatch_enabled = 0 " vim-dispatch needed
  let g:go_metalinter_autosave = 0
  let g:go_metalinter_autosave_enabled = ['vet', 'golint']
  let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

  let g:go_term_enabled = 0
  let g:go_term_mode = "vertical"

  "let g:go_def_mapping_enabled = 1

  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_generate_tags = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_chan_whitespace_error = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_parameters = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_interfaces = 1
  let g:go_highlight_variable_assignments = 1
  let g:go_highlight_variable_declarations = 1

  let g:go_code_completion_enabled = 1

  " 검증 되지 않은 것들 
  let g:go_highlight_string_spellcheck = 1
  let g:go_highlight_format_strings = 1
  let g:go_highlight_array_whitespace_error = 1


  "let g:go_diagnostics_enabled = 1
  let g:go_diagnostics_level = 2
  let g:go_highlight_diagnostic_errors = 1
  let g:go_highlight_diagnostic_warnings = 1

  let g:go_fmt_fail_silently = 1

  "let g:go_def_mode='godef' " gopls, godef, guru
  "let g:go_def_mode='guru' " gopls, godef, guru
  let g:go_def_mode='gopls' " gopls, godef, guru
  let g:go_info_mode='gopls'
  "let g:go_gopls_enabled = 0

  "let g:go_guru_scope = ["github.com/cloud-pi/kraken"]
  "
  " let g:go_gopls_options = ['-remote=auto']
  "let g:go_template_autocreate = 0
  "let g:go_test_timeout= '1s'
  "let g:go_test_show_name = 1

  " for debugging
  "let g:go_echo_command_info=1
  "let g:go_debug=['shell-commands', 'debugger-commands']

endfunction
call VimGoSetup()
