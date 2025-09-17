# Helpful infra utils

A set of opinionated utils to prepare an admin machine to setup a bare-metal server with a single node Kubernetes cluster as well as to help provisioning it.

## Contents

### Overview
```plaintext
.
├── LICENSE.txt
├── README.md
├── scripts
│   ├── local
│   │   ├── dependencies
│   │   │   ├── basics.sh
│   │   │   ├── docker.sh
│   │   │   ├── kubectl.sh
│   │   │   ├── ssh.sh
│   │   │   └── terraform.sh
│   │   └── setup.sh
│   ├── server
│   │   └── transfer_ssh_key.sh
│   ├── setup.sh
│   └── utils.sh
└── terraform
    ├── main.tf
    ├── terraform.tfstate
    ├── terraform.tfvars
    └── terraform.tfvars.template
```

### Items
- `scripts/utils.sh`: A set of generic utils used by most auxiliary scripts
- `scripts/local/`: Where all scripts related to making sure the admin machine is ready to provision the Kubernetes cluster are
- `scripts/setup.sh`: Entrypoint for running the setup (currently, only supports the admin machine and the server DEV environment setup)
- `scripts/server/transfer_ssh_key.sh`: Script used to transfer the Admins public SSH key to the target server host and user
- `terraform/`: IaC powered by Terraform to provision the cluster
- `terraform/dev/terraform.tfvars.template`: Template file containing all required secrets to provision the DEV environment cluster with Terraform

