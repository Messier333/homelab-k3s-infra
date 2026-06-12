terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.109"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
}

locals {
  k3s_master_ip_plain   = split("/", var.k3s_master_ip)[0]
  k3s_worker_1_ip_plain = split("/", var.k3s_worker_1_ip)[0]
}

resource "proxmox_virtual_environment_container" "k3s_master" {
  description = "k3s master lxc"
  node_name   = var.proxmox_node_name
  vm_id       = 101

  started      = true
  unprivileged = true

  initialization {
    hostname = "k3s-master"

    user_account {
      keys = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = var.k3s_master_ip
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }
  }

  operating_system {
    template_file_id = var.lxc_template_file_id
    type             = "debian"
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    swap      = 0
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  features {
    nesting = true
    keyctl  = true
  }
}

resource "proxmox_virtual_environment_container" "k3s_worker_1" {
  description = "k3s worker lxc"
  node_name   = var.proxmox_node_name
  vm_id       = 102

  started      = true
  unprivileged = true

  initialization {
    hostname = "k3s-worker-1"

    user_account {
      keys = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = var.k3s_worker_1_ip
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }
  }

  operating_system {
    template_file_id = var.lxc_template_file_id
    type             = "debian"
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    swap      = 0
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  features {
    nesting = true
    keyctl  = true
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOF
[k3s_master]
k3s-master ansible_host=${local.k3s_master_ip_plain} ansible_user=root

[k3s_workers]
k3s-worker-1 ansible_host=${local.k3s_worker_1_ip_plain} ansible_user=root

[k3s_cluster:children]
k3s_master
k3s_workers
EOF
}
