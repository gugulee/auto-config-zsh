#!/bin/bash

toolDir=$(cd "$(dirname "$0")";pwd)
source $toolDir/dirs
saveDir=`pwd`

# check dirs
echo "check dirs"
[ -z $bashrc ] && exit 1
[ -z $vimConfig ] && exit 1
[ -z $baseDir ] && exit 1

# unset alias
echo "unset alias"
begin=$(cat $bashrc | grep -n "custom config" | cut -d ":" -f 1)
end=$(cat $bashrc | grep -n "end custom" | cut -d ":" -f 1)
if [ ! -z $begin ] && [ ! -z $end ]; then
  sed -i "$begin,$end d" $bashrc
fi 

# clean vim config
echo "clean vim config"
rm -f $vimConfig

# uninstall autojump
echo "uninstall autojump"
begin=$(cat $bashrc | grep -n "autojump config" | cut -d ":" -f 1)
end=$(cat $bashrc | grep -n "end autojump" | cut -d ":" -f 1)
if [ ! -z $begin ] && [ ! -z $end ]; then
  sed -i "$begin,$end d" $bashrc
fi

autojumpDir=$baseDir/autojump
[ ! -d $autojumpDir ] && exit 1
cd $autojumpDir && ./uninstall.py 2>&1 1>/dev/null

cd $saveDir
. $bashrc

echo
echo "==============Please restart terminal(s)=============="
