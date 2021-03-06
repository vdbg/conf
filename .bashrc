
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

## History settings

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


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

if [ "$OS" == "Mac" ]; then
	[ -f /usr/local/git/contrib/completion/git-prompt.sh ] && . /usr/local/git/contrib/completion/git-prompt.sh
	[ -f /usr/local/git/contrib/completion/git-completion.bash ] && . /usr/local/git/contrib/completion/git-completion.bash 
fi

# Include the current e-mail in the prompt
# __git_ps1 may not be available
type -t __git_ps1 | grep -q function
if [ $? -eq 1 ]; then
    # __git_ps1 does not exist
    PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\] ?\[\033[0m\]\n\$ '
else
    # __git_ps1 does exist
    PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1 " 🙂 %s $(git config --get user.email)"`\[\033[0m\]\n\$ '
fi

# start the ssh-agent
function start_agent {
	echo "Initializing new SSH agent..."
	# spawn ssh-agent
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	/usr/bin/ssh-add
	[ -f ~/.ssh/id_rsa_perso ] && ssh-add ~/.ssh/id_rsa_perso
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

add_path() {
	if [ -d "$1" ]; then
		PATH=$1:$PATH
	fi
}

add_alias() {
	if command -v "$2" > /dev/null 2>&1; then
		# handle spaces and parenthesis: test command wants them non escaped while alias command needs them escaped
		command=$2
		command=${command// /\\ }
		command=${command//\(/\\\(}
		command=${command//\)/\\\)}

		alias $1="$command"
	fi
}

# bash alias command cannot accept parameters
f() {
	grep --include=$2 --recursive -i $1
}

add_path "$HOME/bin"
add_path "$HOME/algs4/bin" 
add_path "/f/apps/bin"

##
## Aliases
##


alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias root='cd ~'
alias desktop='cd ~/Desktop'
alias cls=clear
alias dir='ls -AlF'
alias dsb='find . -iname $1'
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'

alias gitp='git pull'
alias gitpp='git push'
alias gits='git status'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitdr='git diff --cached origin/master'
alias gitu='git checkout'
alias gitm='git mergetool'

alias ssh_create='ssh-keygen -t rsa -b 4096 -C "vdb_g@hotmail.com"'
alias ssh_copy='clip < ~/.ssh/id_rsa.pub'

alias xssh='ssh -XC -c blowfish-cbc'

alias aliasf='alias | grep $*'

# git_work() {
#	git config --local user.name "Grégory Vandenbrouck"
#	git config --local user.email gregoryv@microsoft.com
# }

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
			git clean -f -x -d
			git status
		;;
		* )
			echo "OK; not deleting anything."
		;;
	esac
}

if [ "$OS" == "Mac" ]; then
	export CLICOLOR=1
	export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
	alias ssh-work=mwinit && ssh-add -K -t 72000
	add_alias code '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
fi

if [ "$OS" == "Windows" ]; then
	alias n=notepad.exe
	add_alias npp '/c/Program Files (x86)/Notepad++/notepad++.exe'
	add_alias npp '/c/Program Files/Notepad++/notepad++.exe'
	add_alias chrome '/c/Program Files (x86)/Google/Chrome/Application/chrome.exe'
	add_alias rstudio '/c/Program Files/RStudio/bin/rstudio.exe'
	alias snip=snippingtool.exe
fi
if [ "$OS" == "Linux" ]; then
	add_alias n gedit
	add_alias npp gvim
	add_alias chrome chromium-browser 
	add_alias mstsc remmina
	add_alias snip shutter
	add_alias sumatrapdf evince
	add_alias top htop
	# https://github.com/sharkdp/bat/releases
	add_alias cat bat
	# https://github.com/sharkdp/fd/releases
	add_alias find fd
	# curl -O https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
	add_alias ping prettyping
	add_alias du ncdu
	add_alias help tldr

	if [ "${0:0}" != "-" ]; then
		# not a login shell, therefore lacking git completion
		[ -f /etc/bash_completion.d/git-prompt ] && . /etc/bash_completion.d/git-prompt 
	fi
fi
if [ "$OS" == "Linux" -a $UID -ne 0 ]; then
	alias reboot='sudo reboot'
	alias update="sudo -- sh -c 'apt-get update && apt-get dist-upgrade -y && apt autoremove -y && command -v pglcmd > /dev/null 2>&1 && pglcmd update'"

fi

if [ -d "$HOME/Git" ]; then
	export DEV_ROOT=~/Git
elif [ -d "$HOME/git" ]; then
	export DEV_ROOT=~/git
elif [ -d "/f/git" ]; then
	export DEV_ROOT=/f/git
fi

alias dev="cd $DEV_ROOT"

git_sync() {
	pushd "$DEV_ROOT"
	git_recursive 3 pull
	popd
}

git_sync_clean() {
	pushd "$DEV_ROOT"
	git_recursive 3 'pull -p'
	popd
}

git_gc() {
	pushd "$DEV_ROOT"
	git_recursive 3 gc
	popd
}

git_recursive() {
	if [ $1 -eq 0 ]; then
		echo Aborting on `pwd`
		return
	fi
	basename=${PWD##*/}
	if [ "$basename" == "CommonPackages" ]; then
		echo Aborting on`pwd`
		return
	fi
	for dir in $(ls -d */);
	do
		cd $dir
		if [ -d ".git" -o -f ".git" ]; then
			echo
			echo ====================================
			echo Running $2 on `pwd` ...
			git $2
			if [ -f ".gitmodules" ]; then
				git_recursive $(($1 +2)) "$2"
			fi
		else
			git_recursive $(($1 -1)) "$2"
		fi
		cd ..
	done
}

git_status() {
	pushd "$DEV_ROOT"
	git_recursive 3 status
	popd
}

git_wincred() {
	git config --local credential.helper wincred
}

export MY_CONF_ROOT=$DEV_ROOT/conf
export MYVIMRC=$MY_CONF_ROOT/.vimrc


