output "gcp_vm_us_addresses" {
  value = module.gcp_vm_us.ip_nat_vm_tor_obfs4_bridge
}

output "gcp_vm_ca_addresses" {
  value = module.gcp_vm_ca.ip_nat_vm_tor_obfs4_bridge
}
