#!/bin/bash

toolDir=$(cd "$(dirname "$0")";pwd)
source $toolDir/dirs
saveDir=`pwd`

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
tool="autojump"
echo "unset $tool"
begin=$(cat $zshDir | grep -n "# autojump" | cut -d ":" -f 1)
end=$(cat $zshDir | grep -n "# end autojump" | cut -d ":" -f 1)
if [ ! -z $begin ] && [ ! -z $end ]; then
	sed -i "$begin,$end d" $zshDir
fi

oldPlugins=$(grep -E "^plugins=" ~/.zshrc)
oldPlugins=${oldPlugins#*\(}
oldPlugins=${oldPlugins%\)*}

if echo $oldPlugins | grep $tool &>/dev/null;then
	newPlugins=`echo $oldPlugins | sed "s|$tool||g"`
	newPlugins=`echo $newPlugins | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g'`
	newPlugins="plugins=($newPlugins)"
	sed -i "s/^plugins=.*/$newPlugins/g" $zshDir
fi

echo "uninstall autojump"
autojumpDir=$baseDir/autojump
[ ! -d $autojumpDir ] && exit 1
cd $autojumpDir && ./uninstall.py 2>&1 1>/dev/null

cd $saveDir

echo
echo "==============Please restart terminal(s)=============="
