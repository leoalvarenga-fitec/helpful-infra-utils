#!/usr/bin/env

source "$(dirname ${BASH_SOURCE[0]})/../../utils.sh"

provision_dev_with_terraform() {
  cd "$(dirname ${BASH_SOURCE[0]})/../../../terraform/dev"

  local CONFIRMATION=$(PROMPT="Do you really want to provision the DEV server? Typing anything other than \"yes\" will abort >> " EXIT_IF_EMPTY=true FAIL_MSG="Cancelling..." read_and_return)

  if [ "$CONFIRMATION" != "yes" ]; then
    reset
    log_warn "Cancelling..."

    exit 0
  fi

  terraform apply -auto-approve
}

