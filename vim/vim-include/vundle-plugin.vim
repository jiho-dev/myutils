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
Plugin 'jvirtanen/vim-hcl'

" use v1.28: git checkout tags/v1.28 -b tag-v1.28
Plugin 'fatih/vim-go'
"Plugin 'Valloric/YouCompleteMe'

" for PlantUml
"Plugin 'scrooloose/vim-slumlord'
"Plugin 'weirongxu/plantuml-previewer.vim'
"
"
Plugin 'sheerun/vim-polyglot'



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

