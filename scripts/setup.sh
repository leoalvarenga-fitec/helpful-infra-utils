#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/utils.sh"

# Globals
OPTION="$1"

display_help() {
  clear_screen
  reset

  log "\x1b[1;32mSETUP HELPER\x1b[0m"

  log "\nUSAGE"
  log "\t$0 [OPTION]"

  log "\nOPTIONS:"
  log "\t\"admin\" -> Start the setup on this machine to prepare it as an admin local machine able to provision environments"
  log "\t\"server_dev\" -> Start the provisioning process for the DEV environment"

  log "\n\n"
}

setup_admin_local_machine() {
  local entrypoint="$(dirname ${BASH_SOURCE[0]})/local/setup.sh"

  impersonate_root $entrypoint $(whoami)
}

setup_server() {
  local entrypoint="$(dirname ${BASH_SOURCE[0]})/server/setup.sh"

  $entrypoint
}

main() {
  case $OPTION in 
    admin)
      setup_admin_local_machine
    ;;

    server_dev)
      setup_server
    ;;

    *)
      display_help
      exit 1
    ;;
  esac
}

main

