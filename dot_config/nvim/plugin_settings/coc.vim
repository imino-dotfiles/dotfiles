nnoremap [coc] <Nop>
nmap <Space>coc [coc]
nnoremap [coc]l :CocList
nnoremap [coc]in :CocInstall 
nnoremap <silent> [coc]i<Space> :CocInfo<CR>
nnoremap [coc]a :CocAction 
nnoremap [coc]c :CocCommand 
nnoremap <silent> [coc]d :CocDiagnostics<CR>

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
