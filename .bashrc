OS=$(uname -s)

if [ "$OS" == "Darwin" ]; then
    OS=Mac
elif [ "$(expr substr $OS 1 5)" == "Linux" ]; then
    OS=Linux
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    OS=Windows
fi

echo .bashrc $OS

SSH_ENV=$HOME/.ssh/environment

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
alias gits='git status'
alias gitc='git commit'
alias gita='git add'
alias gitd='git diff'
alias gitu='git checkout'

if [ "$OS" == "Windows" ]; then
	alias n=notepad
	alias npp='/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
	alias chrome='/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
fi
if [ "$OS" == "Linux" ]; then
	alias n=gedit
	alias npp=gvim
fi

if [ -d "$HOME/Git" ]; then
	alias dev="cd ~/Git"
elif [ -d "/f/git" ]; then
	alias dev="cd /f/git"
fi


