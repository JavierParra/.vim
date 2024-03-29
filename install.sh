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

initSubmodules || (echo "Failed to init submodules"; exit 1)
# generateHelpTags
