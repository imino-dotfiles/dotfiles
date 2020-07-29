let g:deol#shell_history_path = '~/.local/share/fish/fish_history'

autocmd FileType deol set winblend=30

nnoremap [deol] <Nop>
nmap <Space>dl [deol]
nnoremap <silent> [deol]f :Deol -split=floating<CR>

