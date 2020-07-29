"     _       _ __        _         
"    (_)___  (_) /__   __(_)___ ___ 
"   / / __ \/ / __/ | / / / __ `__ \
"  / / / / / / /__| |/ / / / / / / /
" /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/ 

for f in split(glob('~/.config/nvim/init_vim/*.vim'), '\n')
    execute 'source' f
endfor
