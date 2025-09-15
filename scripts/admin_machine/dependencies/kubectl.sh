#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../../utils.sh"

install_kubectl() {
  # Install deps
  run_silent apt-get install -y apt-transport-https ca-certificates curl gnupg > /dev/null 2>&1

  # For compat with older version of Debian (This should never have to be executed!)
  if [[ ! -d /etc/apt/keyrings ]]; then
     run_silent mkdir -p -m 755 /etc/apt/keyrings > /dev/null 2>&1
  fi

 # Get gpg key
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | gpg --dearmor --batch --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  # Make it unpriveleged for APT programs
  run_silent chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  # Overwrite deb repo for Kubernetes
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' |  tee /etc/apt/sources.list.d/kubernetes.list

  # Make it unpriveleged
  run_silent chmod 644 /etc/apt/sources.list.d/kubernetes.list

  # Updade repos and install it
  run_silent apt-get update

  run_silent apt-get install -y --allow-change-held-packages kubectl
}

