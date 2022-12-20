""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" copy and paste in vim

function! CopyToBuf()
	let firstline = line("'<")
	let lastline  = line("'>")
	let buffile = expand("~/.vimbuf")
	exe 'redir! > ' . buffile
	redir END
	for lno in range(firstline, lastline)
		let copybuf = getline(lno)
		exe 'redir >> ' . buffile
		silent echon copybuf . "\n"
		redir END
	endfor
endfunction

function! PasteFromBuf()
	let buffile = expand("~/.vimbuf")
	let curline = line('.')
	let copybuf =  readfile(buffile)
	call append(curline, copybuf)
endfunction

function! s:GetBufferList() 
  redir =>buflist 
  silent! ls 
  redir END 
  return buflist 
endfunction

function! ToggleQuickfixList()
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))') 
    if bufwinnr(bufnum) != -1
      cclose
      return
    endif
  endfor

  let winnr = winnr()
  copen 10
  if winnr() != winnr
    wincmd p
  endif
endfunction

function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         Errors
    else
        lclose
    endif
endfunction


"""""""""""""""""""""""
function! DoMake()
	if (&ft=='python')
		echo "Syntanx check for Python"
        :SyntasticCheck
		:make!
	else
        :make!
	endif

endfunction

" indexer plugin을 사용하면서, 더이상 필요 없음.
function! UPDATE_TAGS()
	let _f_ = expand("%:p")
	"let _f_ = expand("%:p:h")
	"echo _f_
 	let cwd = getcwd()
  	let tagfilename = cwd . "/tags"
	"let _cmd_ = '"ctags -a -f /dvr/tags --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . _f_ . '"'
	let _cmd_='ctags -R --exclude=bak --exclude=cornerstone-framework-master --exclude=webdoc -I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL'
	let _resp = system(_cmd_)
	unlet _cmd_
	unlet _f_
	unlet _resp
endfunction
"autocmd BufWritePost *.cpp,*.h,*.c,*.cc call UPDATE_TAGS()

" on/off cscope
let g:use_cscope=1

if has("cscope")
"	set csprg=~/bin/cscope
"	set csto=0
"	set cst
"	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
endif

function! RemoveVimSwapFile()
	let _cmd_='rm -f /home/jiho.jung/.vimswp/*'
	let _resp = system(_cmd_)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col-1]!~'\k'
		return "\<TAB>"
	else
	if pumvisible()
		return "\<C-N>"
	else
		return "\<C-N>\<C-P>"
	end
	endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"inoremap <expr> <CR> pumvisible() ? "<C-Y><CR>" : "<CR>"
"hi Pmenu ctermbg=6
"hi PmenuSel ctermbg=yellow ctermfg=black
"hi PmenuSbar ctermbg=blue
