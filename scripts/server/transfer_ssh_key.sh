#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../utils.sh"

format_key() {
  echo $(cat "$1" | sed 's/---- B.*/ssh-rsa /;/Comment:/d;' | sed ':a;N;$!ba;s/\n//g;s/---.*//')
}

send_to_server() {
  if [ -z $4 ]; then
    log "\nExecuting: ssh $1@$2 mkdir -p ~/.ssh && echo $3 >> ~/.ssh/authorized_keys\n"
    
    ssh "$1"@"$2" "mkdir -p ~/.ssh && echo \"$3\" >> ~/.ssh/authorized_keys"
    return
  fi

  log "\nExecuting: ssh $1@$2 -p $4 mkdir -p ~/.ssh && echo $3 >> ~/.ssh/authorized_keys\n"
  ssh "$1"@"$2" -p "$4" "mkdir -p ~/.ssh && echo \"$3\" >> ~/.ssh/authorized_keys"
}

main() {

  log "Please inform the server's:"
  local HOST=$(PROMPT="Host >> " EXIT_IF_EMPTY="y" FAIL_MSG="Host should not be empty..." read_and_return)
  local USER=$(PROMPT="User >> " EXIT_IF_EMPTY="y" FAIL_MSG="User should not be empty..." read_and_return)
  local PORT=$(PROMPT="Port (Optional) >> " read_and_return)

  log "\n"
  local SSH_KEY_PATH=$(PROMPT="Inform the path for your PUBLIC SSH key >> " EXIT_IF_EMPTY="y" FAIL_MSG="No path provided..." read_and_return)

  if [[ ! -f $SSH_KEY_PATH ]]; then
    log_fatal "\n\nPublic SSH key file not valid or not found... (Received: $SSH_KEY_PATH)\n\n"
    exit 1
  fi

  send_to_server "$USER" "$HOST" "$(format_key $SSH_KEY_PATH)" "$PORT"
}

main

