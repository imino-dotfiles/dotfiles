# Defined in - @ line 1
function help --wraps='tldr --list | peco | tldr' --description 'alias help=tldr --list | peco | tldr'
  tldr --list | peco | tldr $argv;
end
