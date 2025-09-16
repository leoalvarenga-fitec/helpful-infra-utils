#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils.sh"

install_docker() {
  run_silent apt-get update
  run_silent install -m 0755 -d /etc/apt/keyrings
  run_silent curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc

  run_silent chmod a+r /etc/apt/keyrings/docker.asc

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  run_silent apt-get update
  run_silent apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

