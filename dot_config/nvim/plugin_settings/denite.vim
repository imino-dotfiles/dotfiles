" nnoremap <Space> [denite]
" nnoremap <Space>p [deniteProject]
" nnoremap <silent> [denite]b :<C-u>Denite buffer<CR>
" nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
" nnoremap <silent> [denite]m :<C-u>Denite file_mru<CR> <silent> <C-u><C-y> :<C-u>Denite neoyank<CR>
" nnoremap <silent> [denite]f :<C-u>Denite file/rec<CR>
" nnoremap <silent> [denite]d :<C-u>Denite directory_rec<CR>

" nnoremap <silent> [deniteProject]b :<C-u>DeniteProject buffer<CR>
" nnoremap <silent> [deniteProject]g :<C-u>DeniteProject grep<CR>
" nnoremap <silent> [deniteProject]m :<C-u>DeniteProject file_mru<CR> <silent> <C-u><C-y> :<C-u>Denite neoyank<CR>
" nnoremap <silent> [deniteProject]f :<C-u>DeniteProject file/rec<CR>
" nnoremap <silent> [deniteProject]d :<C-u>DeniteProject directory_rec<CR>

autocmd FileType denite set winblend=30
autocmd FileType denite-filter set winblend=30

nnoremap [denite] <Nop>
nmap <Space>dn [denite]
nnoremap <silent> [denite]r :Denite file_mru<CR>
nnoremap [denite]c :Denite 
nnoremap <silent> [denite]pc :DeniteProject 
nnoremap <silent> [denite]g<Space> :Denite grep<CR>
nnoremap <silent> [denite]dr :<C-u>Denite file/rec -split=floating<CR>
nnoremap <silent> [denite]gh :Denite ghq<CR>
nnoremap <silent> [denite]h :Denite help<CR>
nnoremap <silent> [denite]mn :Denite memo memo:new<CR>
nnoremap <silent> [denite]mg :Denite memo/grep::!<CR>

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])

call denite#custom#map('insert', "<C-n>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-p>", '<denite:move_to_previous_line>')
call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('insert', "<C-h>", '<denite:do_action:split>')

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs', [
            \ '.git/', 'build/', '__pycache__/',
            \ 'images/', '*.o', '*.make', '*.min.*',
            \ 'img/', 'fonts/', '*~', '*.exe', '*.bak',
            \ '.DS_Store', '*.pyc', '*.class', 'tags'
            \ ])
" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> ll
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction
" use floating
let s:denite_win_width_percent = 0.85
let s:denite_win_height_percent = 0.7
let s:denite_default_options = {
    \ 'split': 'floating',
    \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
    \ 'highlight_filter_background': 'DeniteFilter',
    \ 'prompt': '❯ ',
    \ 'start_filter': v:true,
    \ }
let s:denite_option_array = []
for [key, value] in items(s:denite_default_options)
  call add(s:denite_option_array, '-'.key.'='.value)
endfor
call denite#custom#option('default', s:denite_default_options)
