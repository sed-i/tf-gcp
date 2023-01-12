
output "external_addresses" {
  value = values(google_compute_instance.vm_tor_obfs4_bridge).*.network_interface.0.access_config.0.nat_ip
}
