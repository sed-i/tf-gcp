
resource "google_compute_instance" "vm_tor_obfs4_bridge" {
  count        = var.num_instances
  name         = "${local.tor_obfs4_bridge_resource_name}-${count.index}"
  machine_type = "custom-${var.ncpus}-${var.gbmem * 1024}"
  tags         = ["tor-bridge-internal-traffic", "tor-bridge-ssh-traffic", "node-exporter-scrape"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
      type  = var.disk_type
      size  = "10"
    }
  }

  metadata = {
    user-data = var.rendered_cloud_config
    #    user-data = data.cloudinit_config.tor_obfs4_bridge.rendered
  }

  network_interface {
    network = google_compute_network.tor_bridge_net.name

    access_config {
    }
  }
}

