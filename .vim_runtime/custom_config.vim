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
