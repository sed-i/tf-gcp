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

resource "google_compute_network" "data_science_net" {
  name = "data-science-net"
}

resource "google_compute_firewall" "internal_all_to_all" {
  name    = "internal-all-to-all"
  network = google_compute_network.data_science_net.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags = ["data-science-internal-traffic"]
  source_tags = ["data-science-internal-traffic"]
}

data "http" "myip" {
  # External IP address of the provisioning machine, e.g. your laptop.
  # This is needed for setting up VM's firewall rules.
  url = "http://ipv4.icanhazip.com"
}

resource "google_compute_firewall" "ssh" {
  # For ssh-ing into VMs from the provisioning machine, e.g. your laptop.
  name    = "ssh"
  network = google_compute_network.data_science_net.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["data-science-ssh-traffic"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "external_scrape" {
  # For scraping node-exporter from the provisioning machine, e.g. your laptop.
  name    = "external-scrape"
  network = google_compute_network.data_science_net.name

  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }

  target_tags   = ["node-exporter-scrape"]
  source_ranges = ["${chomp(data.http.myip.body)}/32"]
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

