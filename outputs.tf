output "ip_vm_charm_dev" {
  value = google_compute_instance.vm_charm_dev.network_interface.0.network_ip
}

output "ip_nat_vm_charm_dev" {
  value = google_compute_instance.vm_charm_dev.network_interface.0.access_config.0.nat_ip
}

