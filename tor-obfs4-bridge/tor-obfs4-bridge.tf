data "cloudinit_config" "tor_obfs4_bridge" {
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config
  # https://github.com/hashicorp/terraform-provider-template/blob/79c2094838bfb2b6bba91dc5b02f5071dd497083/website/docs/d/cloudinit_config.html.markdown
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "tor_obfs4_bridge.conf"

    content = yamlencode(
      {
        "write_files" : [
          {
            "path" : "/tor-obfs4-bridge/docker-compose.yml",
            "content" : file("files/docker-compose.yml"),
          },
          {
            "path" : "/tor-obfs4-bridge/.env",
            "content" : templatefile("files/.env.tpl", {
              OR_PORT = var.OR_PORT,
              PT_PORT = var.PT_PORT,
              EMAIL   = var.EMAIL,
            }),
          },
        ],

        "package_update" : "true",

        "packages" : [
          "bat",
          "docker-compose",
          "fzf",
          "git",
          "iftop",
          "iputils-ping",
          "jq",
          "kitty-terminfo",
          "nano",
          "net-tools",
          "python3-pip",
          "tcptrack",
          "unzip",
          "vim",
          "zip",
          "zsh",
        ],

        "runcmd" : [
          templatefile("files/runcmd.tpl.sh", {
          }),
        ]
      }
    )
  }
}


resource "google_compute_instance" "vm_tor_obfs4_bridge" {
  name         = local.tor_obfs4_bridge_resource_name
  machine_type = "custom-${var.ncpus}-${var.gbmem * 1024}"
  tags         = ["tor-bridge-internal-traffic", "tor-bridge-ssh-traffic", "node-exporter-scrape"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
      type  = var.disk_type
      size  = "50"
    }
  }

  metadata = {
    user-data = "${data.cloudinit_config.tor_obfs4_bridge.rendered}"
  }

  network_interface {
    network = google_compute_network.tor_bridge_net.name

    access_config {
    }
  }
}

