function add_to_path -d "Add directory as argument to $fish_user_paths"
  set -U fish_user_paths $fish_user_paths $argv
end
