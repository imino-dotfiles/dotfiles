# Defined in - @ line 1
function xreboot --wraps='sudo systemctl restart lightdm' --description 'alias xreboot=sudo systemctl restart lightdm'
  sudo systemctl restart lightdm $argv;
end
