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

resource "proxmox_virtual_environment_vm" "k3s_master" {
  name      = "k3s-master"
  node_name = var.proxmox_node_name
  vm_id     = 101

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
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
}

resource "proxmox_virtual_environment_vm" "k3s_worker_1" {
  name      = "k3s-worker-1"
  node_name = var.proxmox_node_name
  vm_id     = 102

  clone {
    vm_id = var.vm_template_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
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
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOF
[k3s_master]
k3s-master ansible_host=${local.k3s_master_ip_plain} ansible_user=ubuntu

[k3s_workers]
k3s-worker-1 ansible_host=${local.k3s_worker_1_ip_plain} ansible_user=ubuntu

[k3s_cluster:children]
k3s_master
k3s_workers
EOF
}