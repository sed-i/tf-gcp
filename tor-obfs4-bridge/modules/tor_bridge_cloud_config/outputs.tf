output "rendered_cloud_config" {
  value = data.cloudinit_config.tor_obfs4_bridge.rendered
}
