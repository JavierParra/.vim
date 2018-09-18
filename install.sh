#/bin/bash

MAINDIR=$(dirname `realpath $0`)
function cleanPath() {
	cd $MAINDIR
}

function green() {
	echo "[32m$1[0m"
}

function red() {
	echo "[31m$1[0m"
}

function initSubmodules() {
	cleanPath
	echo "Initializing submodules"
	git submodule init && \
	git submodule update --init --recursive && \
	green "Success" || \
	(red "Failed to init submodules"; \
	return 1)
}

function generateHelpTags() {
	echo "Generating Help Tags"
	vim -c "call pathogen#helptags()" -c "q" > /dev/null && \
	green "Success" || \
	(red "Error generaitng help tags"; \
	return 1)
}

function installYCM() {
	cleanPath
	echo "Installing YouCompleteMe"
	cd ./bundle/YouCompleteMe && \
	./install.py && \
	green "Success" || \
	(red "Failed to install YouCompleteMe see: https://valloric.github.io/YouCompleteMe/#installation"; \
	return 1)
}

function installCommandT() {
	cleanPath
	echo "Installing CommandT"
	(which ruby > /dev/null || \
		(echo "Ruby needs to be installed for commandT"; \
		return 1)\
	) && \
	cd ./bundle/command-t/ruby/command-t/ext/command-t && \
	ruby extconf.rb && \
	make && \
	green "Success" || \
		(red "Failed to install CommandT see: https://github.com/wincent/command-t/blob/master/doc/command-t.txt"; \
		return 1)

}

initSubmodules || (echo "Failed to init submodules"; exit 1)
generateHelpTags
installYCM
installCommandT

