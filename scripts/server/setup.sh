#!/usr/bin/env bash

set -eo pipefail
# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/terraform.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/transfer_ssh_key.sh"

# CRITICALLY IMPORTANT GLOBALS
TASKS=() # Initialized as empty, will append commands as the precheck runs

# Progress tracking
TASKS_DONE=0
TASK_COUNT=0

TITLE="Server - Kubernetes setup"
PROGRESS_MSG_PREFFIX="Executing"

register_task() {
  TASKS+=($1)
  TASK_COUNT=$(( TASK_COUNT + 1 ))
}

mark_as_in_progress() {
  TASKS_DONE=$(( TASKS_DONE + 1 ))
}

display_title() {
  log "\t\e[1;32m$TITLE\e[0m\n"
}

display_progress() {
  clear_screen

  log "\n\n"
  display_title

  log "$PROGRESS_MSG_PREFFIX -> $1"
  log "Progress: $TASKS_DONE/$TASK_COUNT"

  progress_bar $TASKS_DONE $TASK_COUNT
  log "\n\n"
}

# Pre-checks


precheck() {
  # Check if its running Debian
  if [[ -e /etc/debian_release ]]; then
    log_fatal "This script only supports Debian currently..."
  fi

  register_task "transfer_ssh_key"
  register_task "provision_dev_with_terraform"
}

# Main execution



main() {
  toggle_cursor
  precheck

  if [ ${#TASKS[@]} -eq 0 ]; then
    clear_screen
    log "\e[1;32mNothing to do...\e[0m\n\n"

    exit 0
  fi

  for cmd in "${TASKS[@]}"; do
    mark_as_in_progress
    display_progress $cmd

    eval "$cmd"
  done

  PROGRESS_MSG_PREFFIX="Finished"
  display_progress "All done!"

  toggle_cursor
}

main 

