#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils.sh"

install_basics() {
	run_silent apt-get update
  run_silent apt-get upgrade -y

  run_silent apt-get install -y curl lsb-base lsb-release wget unzip jq gnupg
}

