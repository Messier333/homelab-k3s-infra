output "k3s_master_name" {
  value = proxmox_virtual_environment_vm.k3s_master.name
}

output "k3s_master_ip" {
  value = local.k3s_master_ip_plain
}

output "k3s_worker_1_name" {
  value = proxmox_virtual_environment_vm.k3s_worker_1.name
}

output "k3s_worker_1_ip" {
  value = local.k3s_worker_1_ip_plain
}

output "ansible_inventory_path" {
  value = local_file.ansible_inventory.filename
}