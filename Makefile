# ,-.-.     |         ,---.o|         
# | | |,---.|__/ ,---.|__. .|    ,---.
# | | |,---||  \ |---'|    ||    |---'
# ` ' '`---^`   ``---'`    ``---'`---'
# iminotech's Custom Environment for Arch Linux
#
# This depends :
#                git
#                make
#                makepkg


# make variable declaration

export DOTDIR := ${HOME}/.dotfiles

# make variable declaration end

# general arguments

initialize :
            
             cd ~
             git clone https://aur.archlinux.org/yay
             cd yay
             makepkg -sri
             cd ..
             rm -rf    yay

install    :

             mkdir ${DOTDIR}
             make  
             make  
             make  
             make  
             make  
             make  
             make  
             make  
             make  
             make  

remove     :

             rm -rf    ${DOTDIR}

update     :



backup     :

# general arguments end

# individual setups

## initial setups

initial    :

          

## initial setups end

## coding

coding     :



neovim     :



vscode     :



rust       :



haskell    :

              yay        -S stack

dart       :

              yay  -S dart

flutter    :

              yay  -S flutter
              nvim -c ":CocInstall coc-flutter"

elixir     :



julia      :

## desktop

nemo       :



xmonad     :



polybar    :



picom      :



lightdm    :



fonts      :

              yay -S nerd-fonts-jetbrains-mono
              yay -S nerd-fonts-fantasque-sans-mono

## utils

scrot      :
 





























# individual setups end
