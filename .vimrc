set runtimepath^=~/.vim_runtime
source ~/.vim_runtime/vimrc/basic.vim
source ~/.vim_runtime/vimrc/filetypes.vim
source ~/.vim_runtime/vimrc/plugins.vim
source ~/.vim_runtime/vimrc/extended.vim
try
source ~/.vim_runtime/custom_config.vim
catch
endtry
