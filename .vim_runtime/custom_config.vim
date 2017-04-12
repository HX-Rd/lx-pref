" Line number handling
function! NumberToggle()
    if(&rnu == 1)
        set rnu!
    else
        set rnu
    endif
endfunc
nnoremap <Leader>l :call NumberToggle()<cr>

autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType rb setlocal shiftwidth=2 tabstop=2

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END
