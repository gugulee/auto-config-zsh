# when run script by source, $0 is bash
if [ "$0" != "-bash" ];then
    echo "please run script use 'source ${0##*/}'"
        exit 1
fi

toolDir=$(cd "$(dirname "${BASH_ARGV[0]}")";pwd)

. $toolDir/dirs
saveDir=$(pwd)

# check dirs
echo "check dirs"
[ -z $bashrc ] && exit 1
[ -z $vimConfig ] && exit 1
[ -z $baseDir ] && exit 1

# alias config
echo "set alias"
if ! grep "custom config" $bashrc &>/dev/null;then
cat >> $bashrc <<EOF
# custom config
alias l='ls -lrh'
alias grep='grep --color=auto'
alias pss='ps -ef |grep -v grep |grep'
alias ..="cd .."
alias he="history -a" # export history
alias hi="history -n" # import history
# end custom
EOF
fi

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
#autojump
echo "install autojump"
autojumpDir=$baseDir/autojump
if [ ! -d $autojumpDir ];then
    echo "download autojump"
	cd $baseDir
	git clone git://github.com/wting/autojump.git 2>&1 1>/dev/null
fi

[ ! -d $autojumpDir ] && exit 1

cd $autojumpDir && ./install.py 2>&1 1>/dev/null

if [[ -s ~/.autojump/etc/profile.d/autojump.sh ]];then
	. ~/.autojump/etc/profile.d/autojump.sh
	if ! grep "autojump config" $bashrc &>/dev/null;then
cat >> $bashrc <<EOF
# autojump config
. ~/.autojump/etc/profile.d/autojump.sh
# end autojump
EOF
	fi
fi

if ! `which autojump &>/dev/null`;then
    echo "autojump install failed"
    exit 1
fi

echo "autojump install succeed"

. $bashrc
cd $saveDir
