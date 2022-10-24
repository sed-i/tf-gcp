locals {
  data_science_url            = "http://${google_compute_instance.vm_data_science.name}.${var.zone}.c.${var.project}.internal"
  file_provisioner_ssh_key = file(var.ssh_private_key_path)
  data_science_resource_name  = "${var.disk_type}-${var.ncpus}cpu-${var.gbmem}gb"
}

data "cloudinit_config" "data_science" {
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config
  # https://github.com/hashicorp/terraform-provider-template/blob/79c2094838bfb2b6bba91dc5b02f5071dd497083/website/docs/d/cloudinit_config.html.markdown
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = templatefile("data-science.tpl.conf", {
      PROJECT            = var.project,
      ZONE               = var.zone,
      INSTANCE           = local.data_science_resource_name,
    })
    filename = "data_science.conf"
  }
}

resource "google_compute_instance" "vm_data_science" {
  name         = local.data_science_resource_name
  #machine_type = "custom-${var.ncpus}-${var.gbmem * 1024}"
  machine_type = "e2-highmem-8"
  tags         = ["data-science-internal-traffic", "data-science-ssh-traffic", "node-exporter-scrape"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
      type  = var.disk_type
      size  = "50"
    }
  }

  metadata = {
    user-data = "${data.cloudinit_config.data_science.rendered}"
  }

  network_interface {
    network = google_compute_network.data_science_net.name

    access_config {
    }
  }
}

