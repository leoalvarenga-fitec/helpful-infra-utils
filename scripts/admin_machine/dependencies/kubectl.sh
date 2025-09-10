#!/usr/bin/env bash

install_kubectl() {
    # Install deps
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg > /dev/null 2>&1

    # For compat with older version of Debian (This should never have to be executed!)
    if [[ ! -d /etc/apt/keyrings ]]; then
       sudo mkdir -p -m 755 /etc/apt/keyrings > /dev/null 2>&1
    fi

    #if [ -e /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    #    sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    #fi
    
    # Get gpg key
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null 2>&1

    # Make it unpriveleged for APT programs
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null 2>&1

    # Overwrite deb repo for Kubernetes
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null 2>&1

    # Make it unpriveleged
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list > /dev/null 2>&1

    # Updade repos and install it
    sudo apt-get update > /dev/null 2>&1

    sudo apt-get install -y --allow-change-held-packages kubectl > /dev/null 2>&1
}

