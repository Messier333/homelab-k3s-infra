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

variable "vm_template_id" {
  type = number
}

variable "ssh_public_key" {
  type = string
}