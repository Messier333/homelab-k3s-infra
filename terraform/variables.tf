variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_node_name" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "k3s_master_ip" {
  type    = string
  default = "192.168.1.151/24"
}

variable "k3s_worker_1_ip" {
  type    = string
  default = "192.168.1.152/24"
}

variable "gateway" {
  type    = string
  default = "192.168.1.1"
}

variable "dns_servers" {
  type    = list(string)
  default = ["192.168.1.1", "1.1.1.1"]
}

variable "lxc_template_file_id" {
  type = string
}
