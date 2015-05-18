" content of this file is loaded BEFORE all the plugins

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,euc-kr,latin1
set encoding=utf-8



source ~/.vim/bundles.vim  " vundle plugins list
source ~/.vim/global.vim   " general global configuration
source ~/.vim/plugins.vim  " configuration for plugins that needs to be set BEFORE plugins are loaded
source ~/.vim/macros.vim   " some macros

source ~/.vim/before.vim   " local BEFORE configs

if has('gui_running')
  source ~/.vim/gvimrc     " gui specific settings
endif

if has('gui_macvim')
  source ~/.vim/gvimrc     " gui specific settings
endif
" after.vim is loaded from ./after/plugin/after.vim
" which should place it AFTER all the other plugins in the loading order
" bindings.vim and local.vim are loaded from after.vim

