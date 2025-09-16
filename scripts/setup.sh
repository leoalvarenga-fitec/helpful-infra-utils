#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/utils.sh"

# Globals
OPTION="$1"

display_help() {
  clear_screen
  log "\x1b[1;32mSETUP HELPER\x1b[0m"

  log "\nUSAGE"
  log "\t$0 [OPTION]"

  log "\nOPTIONS:"
  log "\t\"admin\" -> Start the setup on this machine to prepare it as an admin local machine able to provision environments"

  log "\n\n"
}

setup_admin_local_machine() {
  local entrypoint="$(dirname ${BASH_SOURCE[0]})/admin_machine/local_machine.sh"

  impersonate_root $entrypoint $(whoami)
}

main() {
  case $OPTION in 
    admin)
      setup_admin_local_machine
    ;;

    server)
      log_warn "Not implemented yet...\n\n"
      exit 1
    ;;

    *)
      display_help
      exit 1
    ;;
  esac
}

main

