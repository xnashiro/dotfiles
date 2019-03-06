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

mackup restore
echo

echo "Finish!"
