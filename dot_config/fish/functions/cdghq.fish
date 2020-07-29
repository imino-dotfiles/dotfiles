# Defined in - @ line 1
function cdghq --wraps='cd (ghq list --full-path | peco)' --description 'alias cdghq=cd (ghq list --full-path | peco)'
  cd (ghq list --full-path | peco) $argv;
end
