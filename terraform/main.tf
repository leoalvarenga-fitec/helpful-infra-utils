terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "null" {}

variable "server_ip" {
  description = "The IP address (preferebly IPv4) of the server machine (whether it's a real box or a VM)"
  type = string
}

variable "server_port" {
  description = "The server machine port open for SSH connections"
  type = number 
}

variable  "ssh_user" {
  description = "SSH user used to log in"
  type = string
}

variable "ssh_private_key" {
  description  = "Path to the private SSH key"
  type = string
}

resource "null_resource" "install_k3s" {
  connection {
    type = "ssh"
    host = var.server_ip
    port = var.server_port
    user = var.ssh_user
    private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update -y",
      "apt-get install -y curl apt-transport-https",
      "curl -sfL https://get.k3s.io | sh -"
      # "curl -sfL https://get.k3s.io | sh -s - server --tls-san ${var.server_ip}" # -> Use this line if you are connecting to a local VM
    ]
  }
}

resource "null_resource" "fetch_newly_created_kubeconfig" {
  depends_on = [null_resource.install_k3s]

  provisioner "local-exec" {
    command = <<EOT
      scp -i ${var.ssh_private_key} scp://${var.ssh_user}@${var.server_ip}:${var.server_port}//etc/rancher/k3s/k3s.yaml ~/
      sed -i "s|127.0.0.1|${var.server_ip}|g" ~/k3s.yaml
    EOT
  }
}

