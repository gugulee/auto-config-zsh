#!/bin/bash

toolDir=$(cd "$(dirname "$0")";pwd)
. $toolDir/dirs
. $toolDir/config.sh

# check dirs
echo "check dirs"
[ -z $vimConfig ] && exit 1
[ -z $baseDir ] && exit 1
[ -z $zshDir ] && exit 1

# clean vim config
echo "clean vim config"
rm -f $vimConfig

# unset oh-my-zsh
echo "unset oh-my-mysh"

# unset autojump
echo "unset autojump"
unSetOhMyZsh "autojump" "$zshDir"

echo "unset zsh-autosuggestions"
unSetOhMyZsh "zsh-autosuggestions" "$zshDir"

# uninstall autojump
echo "uninstall autojump"
autojumpDir=$baseDir/autojump
[ ! -d $autojumpDir ] && exit 1
cd $autojumpDir && ./uninstall.py 2>&1 1>/dev/null

echo
echo "==============Please restart terminal(s)=============="
