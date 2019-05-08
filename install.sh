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
. $toolDir/config.sh

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
echo "install autojump"
toolDir=$baseDir/autojump
if [ ! -d $toolDir ];then
    echo "download autojump"
	cd $baseDir
	git clone git://github.com/wting/autojump.git 2>&1 1>/dev/null
fi

[ ! -d $toolDir ] && exit 1

cd $toolDir && ./install.py 2>&1 1>/dev/null

if [[ ! -s ~/.autojump/etc/profile.d/autojump.sh ]];then
	echo "autojump install failed"
fi

# install zsh-autosuggestions
echo "install zsh-autosuggestions"
toolDir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
if [ ! -d $toolDir ];then
    echo "download zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions $toolDir 2>&1 1>/dev/null
fi

[ ! -d $toolDir ] && exit 1

#config on-my-zsh
echo "set on-my-zsh"

# set autojump
echo "set autojump"
content="[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh"
setOhMyZsh "autojump" "$zshDir" "$content"

# set zsh-autosuggestions
echo "set zsh-autosuggestions"
content="export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"fg=3\""
setOhMyZsh "zsh-autosuggestions" "$zshDir" "$content"

echo
echo "==============Please restart terminal(s)=============="
