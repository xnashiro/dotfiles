#!/usr/bin/env bash

set -eu

DOTPATH=$HOME/dotfiles

if [ ! -d "$DOTPATH" ]; then
    git clone https://github.com/nashirox/dotfiles.git "$DOTPATH"
else
    echo "$DOTPATH already exists. Updating..."
    cd "$DOTPATH"
    git stash
    git checkout master
    git pull origin master
    echo
fi

cd "$DOTPATH"

# install homebrew
if ! command -v brew > /dev/null 2>&1; then
    # Install homebrew: https://brew.sh/
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo
fi
brew bundle
echo

# GPG
# set -x GPG_TTY (tty)

mackup restore

# fisher add jethrokuan/fzf
# To use nvm
# fisher add FabioAntunes/fish-nvm
# fisher add edc/bass

echo

echo "Finish!"
