#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils.sh"

setup_ssh_key() {
	clear_screen
	display_title
	
  toggle_cursor
  local USER_EMAIL=$(PROMPT="What is your email? >> " EXIT_IF_EMPTY="true" FAIL_MSG="User email is empty or invalid. Bailing out... (Received: \"$USER_EMAIL\")" read_and_return)
  local SSH_KEY_PATH=$(PROMPT="What path should the new private SSH key be placed? >> " EXIT_IF_EMPTY="true" FAIL_MSG="Path is invalid. Bailing out... (Received: \"$\")" read_and_return)
  toggle_cursor

  log "\n\n"
  log_warn "You will be prompted for a few options. Leave all of them empty unless asked to overwrite\n"
  sleep 4

  toggle_cursor
	run_silent apt-get install -y openssh-client
	ssh-keygen -f "$SSH_KEY_PATH" -t ed25519 -C "$USER_EMAIL"
  toggle_cursor

  chown $ORIGINAL_USER $SSH_KEY_PATH
}

