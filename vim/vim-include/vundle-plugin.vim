""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin 에 관련한 정의
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=~/.vim/bundle/vundle
call vundle#rc()
"""""""""""""""""""""
Plugin 'gmarik/vundle'

"Plugin 'Chiel92/vim-autoformat'

"Plugin 'indexer.tar.gz'
"Plugin 'vimprj'
"Plugin 'DfrankUtil'
"Plugin 'The-NERD-tree'
"Plugin 'francoiscabrol/ranger.vim'
"Plugin 'git://github.com/klen/python-mode.git'
"Plugin 'scrooloose/syntastic'
"
Plugin 'hashivim/vim-terraform'

Plugin 'fatih/vim-go'
"Plugin 'Valloric/YouCompleteMe'

" for PlantUml
"Plugin 'scrooloose/vim-slumlord'
"Plugin 'weirongxu/plantuml-previewer.vim'


"
"
":BundleSearch
":BundleInstall
":BundleClean
":GoInstallBinaries
":GoUpdateBinaries

"""""""""""""""""""""
call vundle#end()            " required

let g:vundle#lazy_load = 1

