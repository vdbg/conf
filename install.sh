#!/bin/sh
echo . \"$( cd $(dirname $0) ; pwd -P )/.bashrc\" > ~/.bashrc

cp .bash_profile ~
cp .inputrc ~
cp .gitconfig-template ~/.gitconfig



