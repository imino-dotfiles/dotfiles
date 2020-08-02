# Defined in - @ line 1
function view --wraps='nvim -M' --description 'alias view=nvim -M'
  nvim -M $argv;
end
