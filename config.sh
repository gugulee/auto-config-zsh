#!/bin/bash

# parameter list: tool zshDirsetContent customConfig
setOhMyZsh()
{
	local tool=$1
	local zshDir=$2
	local setContent=$3

	oldPlugins=$(grep -E "^plugins=" $zshDir)
	oldPlugins=${oldPlugins#*\(}
	oldPlugins=${oldPlugins%\)*}

	if ! echo $oldPlugins | grep $tool &>/dev/null;then
    	newPlugins="plugins=($oldPlugins $tool)"
    	sed -i "s/plugins=.*/$newPlugins/g" $zshDir
	fi

	if ! grep "# $tool" $zshDir &>/dev/null;then
	cat >> $zshDir <<EOF
# $tool
$setContent
# end $tool
EOF
	fi
}

# parameter list: tool zshDirsetContent
unSetOhMyZsh()
{
	local tool=$1
	local zshDir=$2

	begin=$(cat $zshDir | grep -n "# $tool" | cut -d ":" -f 1)
	end=$(cat $zshDir | grep -n "# end $tool" | cut -d ":" -f 1)
	if [ ! -z $begin ] && [ ! -z $end ]; then
    	sed -i "$begin,$end d" $zshDir
	fi

	oldPlugins=$(grep -E "^plugins=" $zshDir)
	oldPlugins=${oldPlugins#*\(}
	oldPlugins=${oldPlugins%\)*}

	if echo $oldPlugins | grep $tool &>/dev/null;then
    	newPlugins=`echo $oldPlugins | sed "s|$tool||g"`
    	newPlugins=`echo $newPlugins | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g'`
    	newPlugins="plugins=($newPlugins)"
    	sed -i "s/^plugins=.*/$newPlugins/g" $zshDir
	fi
}
