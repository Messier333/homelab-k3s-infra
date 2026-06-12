output "k3s_master_name" {
  value = proxmox_virtual_environment_container.k3s_master.initialization[0].hostname
}

output "k3s_master_ip" {
  value = local.k3s_master_ip_plain
}

output "k3s_worker_1_name" {
  value = proxmox_virtual_environment_container.k3s_worker_1.initialization[0].hostname
}

output "k3s_worker_1_ip" {
  value = local.k3s_worker_1_ip_plain
}

output "ansible_inventory_path" {
  value = local_file.ansible_inventory.filename
}