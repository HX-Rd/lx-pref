" Load pathogen paths
call pathogen#infect('~/.vim_runtime/bundle/forked/{}')
call pathogen#infect('~/.vim_runtime/bundle/pristine/{}')
call pathogen#helptags()

"------------------------------------------------------------------------------
" Custom color scheme
"------------------------------------------------------------------------------
try
    colorscheme foursee
catch
endtry

"------------------------------------------------------------------------------
" NERDTree
"------------------------------------------------------------------------------

" General properties
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1
let NERDTreeIgnore=['\.o$', '\.pyc$', '\.php\~$']
let NERDTreeWinSize = 35

" Make sure that when NT root is changed, Vim's pwd is also updated
let NERDTreeChDirMode = 2
let NERDTreeShowLineNumbers = 1
let NERDTreeAutoCenter = 1

" Open NERDTree on startup, when no file has been specified
autocmd VimEnter * if !argc() | NERDTree | endif

" Locate file in hierarchy quickly
map <leader>T :NERDTreeFind<cr>

" Toogle on/off
nmap <leader>o :NERDTreeToggle<cr>


"------------------------------------------------------------------------------
" BufExplorer
"------------------------------------------------------------------------------

" Shortcuts, type <leader>l to quickly navigate to necessary buffer
map <leader>k :BufExplorer<cr>
imap <leader>k <esc>:BufExplorer<cr>
vmap <leader>k <esc>:BufExplorer<cr>


"------------------------------------------------------------------------------
" Fugitive
"------------------------------------------------------------------------------
map ]] ]c
map [[ [c
map <leader>gdi :Gdiff<cr>
map <leader>gst :Gstatus<cr>
map <leader>dup :diffupdate<cr>

"------------------------------------------------------------------------------
" Syntastic
"------------------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"------------------------------------------------------------------------------
" CtrlP
"------------------------------------------------------------------------------
let g:ctrlp_show_hidden = 1

"------------------------------------------------------------------------------
" NeoComplete
"------------------------------------------------------------------------------

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Close popup by <Space>.
" inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
"inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" AutoComplPop like behavior.
let g:neocomplete#enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
"  let g:neocomplete#sources#omni#input_patterns = {}
"endif
"let g:neocomplete#force_omni_input_patterns.go = '[^.[:digit:] *\t]\.'
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
"let g:neocomplete#force_omni_input_patterns.go = '[^.[:digit:] *\t]\.'

"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

"------------------------------------------------------------------------------
" Pyclewn
"------------------------------------------------------------------------------
let g:pyclewn_args = "--window=bottom"
function! FixClewnGeneratedFunctions(filepath)
    execute "edit " . a:filepath
    let unmapkeysfunc = '%s/function s:unmapkeys()/function! s:unmapkeys()/g'
    execute unmapkeysfunc
    let exitclewnfunc = '%s/function s:exitclewn()/function! s:exitclewn()/g'
    execute exitclewnfunc
    let argfunc = '%s/function s:Arg_(A, L, P)/function! s:Arg_(A, L, P)/g'
    execute argfunc
    let arghelpfunc = '%s/function s:Arg_help(A, L, P)/function! s:Arg_help(A, L, P)/g'
    execute arghelpfunc
    let argloglevel = '%s/function s:Arg_loglevel(A, L, P)/function! s:Arg_loglevel(A, L, P)/g'
    execute argloglevel
    write
    Bclose
endfun
