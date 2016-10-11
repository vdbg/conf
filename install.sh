#!/bin/sh
echo . \"$( cd $(dirname $0) ; pwd -P )/.bashrc\" > ~/.bashrc

cp .bash_profile ~
cp .inputrc ~
cp .gitconfig-template ~/.gitconfig

# Set vimrc's location and source it on vim startup
# VIMINIT does not always work
# export VIMINIT=':silent source "$MYVIMRC"'
[ ! -f ~/.vimrc ] && ln -s "$MYVIMRC" ~/.vimrc
