terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

locals {
  tor_bridge_internal_url        = "http://${google_compute_instance.vm_tor_obfs4_bridge.name}.${var.zone}.c.${var.project}.internal"
  file_provisioner_ssh_key       = file(var.ssh_private_key_path)
  tor_obfs4_bridge_resource_name = "tor-obfs4-bridge-${var.ncpus}cpu-${var.gbmem}gb"
}

resource "google_compute_network" "tor_bridge_net" {
  name = "tor-bridge-net"
}

resource "google_compute_firewall" "internal_all_to_all" {
  name    = "internal-all-to-all"
  network = google_compute_network.tor_bridge_net.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags = ["tor-bridge-internal-traffic"]
  source_tags = ["tor-bridge-internal-traffic"]
}

data "http" "myip" {
  # External IP address of the provisioning machine, e.g. your laptop.
  # This is needed for setting up VM's firewall rules.
  url = "http://ipv4.icanhazip.com"
}

resource "google_compute_firewall" "ssh" {
  # For ssh-ing into VMs from the provisioning machine, e.g. your laptop.
  name    = "ssh"
  network = google_compute_network.tor_bridge_net.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["tor-bridge-ssh-traffic"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tor_obs4_bridge_ports" {
  # Ports needed for to expose to the internet for the bridge to work
  name    = "tor-obs4-bridge-ports"
  network = google_compute_network.tor_bridge_net.name

  allow {
    protocol = "tcp"
    ports    = [var.OR_PORT, var.PT_PORT]
  }

  target_tags   = ["tor-bridge-ssh-traffic"]
  source_ranges = ["0.0.0.0/0"]
}

locals {
  ssh_keys = <<EOF
    ubuntu:${file(var.ssh_public_key_path)}
  EOF
}

resource "google_compute_project_metadata" "gcp_metadata" {
  metadata = {
    ssh-keys = local.ssh_keys
  }
}

