#!/usr/bin/env bash

set -eo pipefail
# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/basics.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/docker.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/terraform.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/kubectl.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dependencies/ssh.sh"

# CRITICALLY IMPORTANT GLOBALS
TASKS=() # Initialized as empty, will append commands as the precheck runs
USER_EMAIL=""
ORIGINAL_USER="$1"

# Progress tracking
TASKS_DONE=0
TASK_COUNT=0

TITLE="Admin - Local machine setup"
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

  if [[ $(whoami) != "root" ]]; then
    log_fatal "This script MUST be ran as ROOT. Use sudo, su, or other privilege escalation method to run it..."
  fi

  register_task "install_basics"

  if ! has_output docker --version; then
     register_task "install_docker"
  fi

  # If terraform is not present in the admin local machine
  if ! has_output terraform -v; then
    register_task "install_terraform"
  fi

  if ! has_output kubectl version --client; then
    register_task "install_kubectl"    
  fi

  register_task "setup_ssh_key"
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

