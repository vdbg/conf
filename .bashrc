OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
    OS=Mac
elif [ "$(expr substr $OS 1 5)" == "Linux" ]; then
    OS=Linux
elif [ "$(expr substr $OS 1 10)" == "MINGW32_NT" ]; then
    OS=Windows
elif [ "$(expr substr $OS 1 10)" == "MINGW64_NT" ]; then
    OS=Windows
fi

# printing stuff in .bashrc results in sftp failing
# echo .bashrc $OS

SSH_ENV=$HOME/.ssh/environment

## Too slow :(
# GIT_PS1_SHOWDIRTYSTATE=yes
# GIT_PS1_SHOWSTASHSTATE=yes
# GIT_PS1_SHOWUNTRACKEDFILES=yes

# Include the current e-mail in the prompt
PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1 " (%s $(git config --get user.email)) "`\[\033[0m\]\n\$ '

# start the ssh-agent
function start_agent {
	echo "Initializing new SSH agent..."
	# spawn ssh-agent
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	/usr/bin/ssh-add
}

if [ "$OS" == "Windows" ]; then
	if [ -f "${SSH_ENV}" ]; then
		. "${SSH_ENV}" > /dev/null
		ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
			start_agent;
		}
	else
		start_agent;
	fi
fi

if [ -d "$HOME/bin" ]; then
	PATH=$HOME/bin:$PATH
fi

if [ -d "$HOME/algs4/bin" ]; then
	PATH=$PATH:$HOME/algs4/bin
fi

if [ -d "/f/apps/bin" ]; then
	PATH=$PATH:/f/apps/bin
fi

if [ "$OS" == "Linux" -a $UID -ne 0 ]; then
    alias reboot='sudo reboot'
    alias update='sudo apt-get upgrade'
fi



##
## Aliases
##

alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias root='cd ~'
alias desktop='cd ~/Desktop'
alias cls=clear
alias dir='ls -AlF'

alias gitp='git pull'
alias gitpp='git push'
alias gits='git status'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitu='git checkout'

git_work() {
	git config --local user.name "Grégory Vandenbrouck"
	git config --local user.email gregoryv@microsoft.com
}

git_perso() {
	git config --local user.name vdbg
	git config --local user.email vdb_g@hotmail.com
}

git_prompt() {
	. /etc/bash_completion.d/git-prompt 
}

git_nuke() {
	git status
	read -p "WARNING: NUKE everything under $PWD (y/n)? " answer
	case ${answer:0:1} in
		y|Y )
			echo "NUKING"
			git reset HEAD
			git checkout .
			git clean -f
			git status
		;;
		* )
			echo "OK; not deleting anything."
		;;
	esac
}

if [ "$OS" == "Windows" ]; then
	alias n=notepad
	alias npp='/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
	alias chrome='/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
	alias rstudio='/c/Program\ Files/RStudio/bin/rstudio.exe'
fi
if [ "$OS" == "Linux" ]; then
	alias n=gedit
	alias npp=gvim
fi

if [ -d "$HOME/Git" ]; then
	export DEV_ROOT=~/Git
elif [ -d "/f/git" ]; then
	export DEV_ROOT=/f/git
fi

alias dev="cd $DEV_ROOT"

git_sync() {
	for folder in docs prog conf
	do
		pushd $DEV_ROOT/$folder
		git pull
		popd
	done
}

git_status() {
	pushd "$DEV_ROOT"
	for dir in $(ls -d */);
	do
		echo
		echo ====================================
		echo Status in $dir:
		cd $dir
		git status
		cd ..
	done
	popd
}

export MY_CONF_ROOT=$DEV_ROOT/conf
export MYVIMRC=$MY_CONF_ROOT/.vimrc
# Set vimrc's location and source it on vim startup
# VIMINIT does not always work
# export VIMINIT=':silent source "$MYVIMRC"'
[ ! -f ~/.vimrc ] && ln -s "$MYVIMRC" ~/.vimrc


