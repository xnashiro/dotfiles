#!/bin/bash

set -eu

sudo apt update
sudo apt upgrade
sudo apt install -y build-essential procps curl file git gcc zlib1g-dev

# set dotflies
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

# install Homebrew
if !(type brew > /dev/null 2>&1); then
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
    echo 'eval "$(rbenv init - bash)"' >> $HOME/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    . $HOME/.profile
    echo
fi

# update Homebrew
brew update && brew outdated && brew upgrade && brew cleanup

# bundle for common
brew bundle

# bundle for macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew bundle --file $DOTPATH/macos/Brewfile
fi

# install latest Ruby
if !(type ruby > /dev/null 2>&1); then
    LATEST_RUBY_VERSION=$(rbenv install -l | grep -v - | tail -1)
    rbenv install $LATEST_RUBY_VERSION
    rbenv global $LATEST_RUBY_VERSION
    echo 'export PATH="/home/linuxbrew/.linuxbrew/bin/rbenv:$PATH"' >> $HOME/.profile
    echo 'eval "$(rbenv init - bash)"' >> $HOME/.profile
    . $HOME/.profile
fi

# install latest Python
if !(type python > /dev/null 2>&1); then
    pyenv install 3.10.4
    pyenv global 3.10.4
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
    echo 'eval "$(pyenv init -)"' >> ~/.profile
fi

# install latest node
if !(type node > /dev/null 2>&1); then
    volta install node
    volta setup
    . $HOME/.profile
fi


# clean up...
sudo apt autoremove
brew cleanup

echo "Setup finished!"
