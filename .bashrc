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

if [ -f "~/bin" ]; then
	PATH=~/bin:$PATH
fi

if [ "$OS" == "Linux" -a $UID -ne 0 ]; then
    alias reboot='sudo reboot'
    alias update='sudo apt-get upgrade'
fi



##
## Aliases
##

# OS agnostic

alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias root='cd ~'


if [ "$OS" == "Windows" ]; then
	alias n=notepad
	alias npp='/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe'
fi
if [ "$OS" == "Linux" ]; then
	alias n=gedit
	alias npp=gvim
fi

if [ -d "~/Git" ]; then
	alias dev="cd ~/Git"
elif [ -d "/f/git" ]; then
	alias dev="cd /f/git"
fi


