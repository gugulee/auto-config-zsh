if ! `which zsh &>/dev/null`;then
    echo "please install zsh first (yum -y install zsh)"
    exit 1
fi

ls ~/.zshrc &>/dev/null
if [ $? != 0 ];then
	echo "please install oh-my-zsh first (sh -c \"$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)\")"
	exit 1
fi

toolDir=$(cd "$(dirname "${BASH_ARGV[0]}")";pwd)

. $toolDir/dirs
saveDir=$(pwd)

# check dirs
echo "check dirs"
[ -z $vimConfig ] && exit 1
[ -z $baseDir ] && exit 1
[ -z $zshDir ] && exit 1

# vim config
echo "set vim"
if ! grep "custom config" $vimConfig &>/dev/null;then
cat >> $vimConfig <<EOF
"custom config"
set ts=4 
set sw=4
EOF
fi	

# validate network
if ! `curl -k www.github.com &>/dev/null` ;then
	echo "connect www.github.com failed"
	exit 1
fi

# check git 
if ! `which git &>/dev/null`;then
	echo "git not install"
	exit 1
fi

# create tool dir
if [ ! -d "$baseDir" ];then
	echo "create tools dir: '$baseDir'"
    mkdir -p $baseDir
fi

# Productivity tool
#
# install autojump
tool="autojump"
echo "install $tool"
toolDir=$baseDir/$tool
if [ ! -d $toolDir ];then
    echo "download $tool"
	cd $baseDir
	git clone git://github.com/wting/autojump.git 2>&1 1>/dev/null
fi

[ ! -d $toolDir ] && exit 1

cd $toolDir && ./install.py 2>&1 1>/dev/null

if [[ ! -s ~/.autojump/etc/profile.d/autojump.sh ]];then
	echo "$tool install failed"
fi

#config on-my-zsh
echo "set on-my-zsh"

# set autojump
echo "set $tool"
oldPlugins=$(grep -E "^plugins=" $zshDir)
oldPlugins=${oldPlugins#*\(}
oldPlugins=${oldPlugins%\)*}

if ! echo $oldPlugins | grep $tool &>/dev/null;then
	newPlugins="plugins=($oldPlugins $tool)"
	sed -i "s/plugins=.*/$newPlugins/g" $zshDir
fi

if ! grep "# autojump" $zshDir &>/dev/null;then
cat >> $zshDir <<EOF
# autojump
[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh
# end autojump
EOF
fi

cd $saveDir

echo
echo "==============Please restart terminal(s)=============="
