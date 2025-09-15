#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils.sh"

setup_ssh_key() {
	clear_screen
	display_title
	
	local USER_EMAIL=""
  
  toggle_cursor
	read -p "What is your email? >> " USER_EMAIL
  toggle_cursor

	if [[ -z $USER_EMAIL ]]; then
		log_fatal "User email is empty or invalid. Bailing out... (Received: \"$USER_EMAIL\")"
	fi


  log "\n\n"
  log_warn "You will be prompted for a few options. Leave all of them empty unless asked to overwrite\n"
  sleep 4

  toggle_cursor
	run_silent apt-get install -y openssh-client
	ssh-keygen -t ed25519 -C "$USER_EMAIL"
  toggle_cursor
}

