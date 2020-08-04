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
             rm -rf yay
             yay -S --noconfirm expect chezmoi wget curl
             cd sudo_zone
             sudo make

install    : coding desktop update utils

remove     :



update     :

             chezmoi apply

backup     :

# general arguments end

# individual setups

## coding

coding     : neovim jetbrains

neovim     :

              yay -S --noconfirm neovim
              pip3 install pynvim
              yarn install neovim
              nvim -c "call dein#update()"
              nvim -c "UpdateRemotePlugin"

jetbrains  :

              wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.17.7275.tar.gz
              tar -xf jetbrains-toolbox-1.17.7275.tar.gz -C ~/.local/share/
              rm -f jetbrains-toolbox-1.17.7275.tar.gz

vscode     :
              
              yay -S --noconfirm code

rust       :

              expect -c "
              spawn curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
              expect \">\"
              send \"1\"
              "
              rustup install stable
              rustup default stable
              rustup component add rls rust-analysis rust-src

go         :

              yay -S --noconfirm go 
              go get -u golang.org/x/lint/golint
              GO111MODULE=on go get golang.org/x/tools/gopls@latest

haskell    :

              yay -S --noconfirm stack

dart       :

              yay  -S --noconfirm dart

flutter    :

              yay  -S --noconfirm flutter
              nvim -c ":CocInstall coc-flutter"

elixir     :

              yay -S --noconfirm elixir
              mix local.hex --force

julia      :

              yay -S --noconfirm julia openblas
              julia -e 'using Pkg; Pkg.add.([PkgTemplates,Lint,LanguageServer])'

python     :

              yay -S --noconfirm python3

node       :

              yay -S --noconfirm nodejs yarn

## desktop

desktop    : nemo xmonad polybar picom polybar picom lightdm scrot

nemo       :

              yay -S --noconfirm nemo nemo-fileroller

xmonad     :

              yay -S --noconfirm xmonad xmonad-contrib

polybar    :

              yay -S --noconfirm polybar

picom      :

              yay -S --noconfirm picom-rounded-corners

lightdm    :

              yay -S --noconfirm lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan-git

fonts      :

              yay -S --noconfirm nerd-fonts-jetbrains-mono
              yay -S --noconfirm nerd-fonts-fantasque-sans-mono

## utils

utils      : scrot

scrot      :
 
              yay -S --noconfirm scrot





























# individual setups end
