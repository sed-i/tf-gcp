locals {
  charm_dev_url            = "http://${google_compute_instance.vm_charm_dev.name}.${var.zone}.c.${var.project}.internal"
  file_provisioner_ssh_key = file(var.ssh_private_key_path)
  charm_dev_resource_name  = "${var.disk_type}-${var.ncpus}cpu-${var.gbmem}gb"
}

data "cloudinit_config" "charm_dev" {
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config
  # https://github.com/hashicorp/terraform-provider-template/blob/79c2094838bfb2b6bba91dc5b02f5071dd497083/website/docs/d/cloudinit_config.html.markdown
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = templatefile("charm-dev.tpl.conf", {
      PROJECT            = var.project,
      ZONE               = var.zone,
      INSTANCE           = local.charm_dev_resource_name,
      LXD_CHANNEL        = var.lxd,
      JUJU_CHANNEL       = var.juju,
      MICROK8S_CHANNEL   = var.microk8s,
      CHARMCRAFT_CHANNEL = var.charmcraft,
    })
    filename = "charm_dev.conf"
  }
}

resource "google_compute_instance" "vm_charm_dev" {
  name         = local.charm_dev_resource_name
  machine_type = "custom-${var.ncpus}-${var.gbmem * 1024}"
  tags         = ["charm-dev-internal-traffic", "charm-dev-ssh-traffic", "node-exporter-scrape"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2104-hirsute-v20211119"
      type  = var.disk_type
      size  = "50"
    }
  }

  metadata = {
    user-data = "${data.cloudinit_config.charm_dev.rendered}"
  }

  network_interface {
    network = google_compute_network.charm_dev_net.name

    access_config {
    }
  }
}

