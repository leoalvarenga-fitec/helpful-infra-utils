#!/usr/bin/env bash

setup_ssh_key() {
	clear_screen
	display_title
	
	local USER_EMAIL=""

	read -p "What is your email? >> " USER_EMAIL

	if [[ -z $USER_EMAIL ]]; then
		log "[FATAL] User email is empty or invalid. Bailing out... (Received: \"$USER_EMAIL\")"
		exit 1
	fi

	sudo apt-get install -y openssh-client > /dev/null 2>&1
	ssh-keygen -t ed25519 -C "$USER_EMAIL" > /dev/null 2>&1
}

