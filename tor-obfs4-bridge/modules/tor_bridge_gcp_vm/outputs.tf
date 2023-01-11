output "ip_vm_tor_obfs4_bridge" {
  value = flatten(google_compute_instance.vm_tor_obfs4_bridge[*].network_interface[0].network_ip)
}

output "ip_nat_vm_tor_obfs4_bridge" {
  value = flatten(google_compute_instance.vm_tor_obfs4_bridge[*].network_interface.0.access_config.0.nat_ip)
}

