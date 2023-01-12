locals {
  nodes = flatten([for node in var.instances :
    [
      for i in range(node.num_instances) :
      {
        idx  = i
        zone = node.zone
      }
    ]
  ])
}


resource "google_compute_instance" "vm_tor_obfs4_bridge" {
  for_each = { for itm in local.nodes : "${itm.zone}-${itm.idx}" => itm.zone }
  name     = "${local.tor_obfs4_bridge_resource_name}-${each.key}"
  zone         = each.value
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
  }

  network_interface {
    network = google_compute_network.tor_bridge_net.name

    access_config {
    }
  }
}

