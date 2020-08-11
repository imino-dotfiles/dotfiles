let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 0
let g:loaded_netrwPlugin       = 0
let g:loaded_netrwSettings     = 0
let g:loaded_netrwFileHandlers = 0
let g:netrw_keepdir            = 0

augroup init
  autocmd BufEnter     * execute ":lcd "     .  expand("%:p:h")
  autocmd BufEnter     * set     relativenumber
  autocmd BufEnter     * set     shiftwidth=2
  autocmd BufEnter     * set     expandtab

  " Save fold settings.
  autocmd BufWritePost * if      expand('%') != '' && &buftype !~ 'nofile' | mkview |        endif
  autocmd BufRead      * if      expand('%') != '' && &buftype !~ 'nofile' | silent! loadview | endif
augroup   END


if has('persistent_undo')
  let s:undodir = expand('~/.config/nvim/undo')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p')
    endif
  set undodir=~/.config/nvim/undo
  set undofile                                            
endif

set termguicolors
let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"


set cursorline
set cursorcolumn

set noshowmode

set list listchars=tab:\▸\-
set tabstop=2
set softtabstop=2
set pumblend=15
set winblend=30
set shiftwidth=2
set mouse=a

if &modifiable
  set encoding=utf-8
  set termencoding=utf-8
  set fileencoding=utf-8
  set fileencodings=utf-8,cp932,euc-jp
endif

set runtimepath+=~/.config/nvim/user-functions
set clipboard+=unnamedplus
