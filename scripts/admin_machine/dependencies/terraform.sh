install_terraform() {
    {
        # Install deps
        sudo apt-get update > /dev/null 2>&1 
        sudo apt-get install -y gnupg > /dev/null 2>&1

        # Install HashiCorp's gpg key
        wget -qO- https://apt.releases.hashicorp.com/gpg | \
            gpg --dearmor | \
            sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null 2>&1

        # Add HashiCorp's official repo
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null 2>&1

        # Reupdate
        sudo apt update > /dev/null 2>&1

        # Install terraform
        sudo apt-get install -y terraform > /dev/null 2>&1
    } > /dev/null 
}

