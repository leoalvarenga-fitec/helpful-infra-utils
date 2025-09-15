install_terraform() {
  # Install deps
  run_silent apt-get update

  # Install HashiCorp's gpg key
  wget -qO- https://apt.releases.hashicorp.com/gpg | \
      gpg --dearmor | \
      tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null 2>&1

  # Add HashiCorp's official repo
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list

  # Reupdate
  run_silent apt update

  # Install terraform
  run_silent apt-get install -y terraform
}

