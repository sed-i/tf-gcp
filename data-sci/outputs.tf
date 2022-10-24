output "ip_vm_data_science" {
  value = google_compute_instance.vm_data_science.network_interface.0.network_ip
}

output "ip_nat_vm_data_science" {
  value = google_compute_instance.vm_data_science.network_interface.0.access_config.0.nat_ip
}

