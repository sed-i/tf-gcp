locals {
  gcp_project_name     = "data-science-90210"
  gcp_credentials_file = "~/secrets/data-science-90210-40d03fb93e62.json"
  ssh_public_key_path  = "~/secrets/gcp-tor-obfs4-bridge-ssh.pub"
}


module "tor_bridge_cloud_config" {
  source = "./modules/tor_bridge_cloud_config"
  EMAIL  = var.EMAIL
}

module "gcp_vm_us" {
  source = "./modules/tor_bridge_gcp_vm"

  project             = local.gcp_project_name
  credentials_file    = local.gcp_credentials_file
  ssh_public_key_path = local.ssh_public_key_path

  region                = "us-central1"
  zone                  = "us-central1-a"
  num_instances         = 1
  rendered_cloud_config = module.tor_bridge_cloud_config.rendered_cloud_config
}

module "gcp_vm_ca" {
  source = "./modules/tor_bridge_gcp_vm"

  project             = local.gcp_project_name
  credentials_file    = local.gcp_credentials_file
  ssh_public_key_path = local.ssh_public_key_path

  region                = "northamerica-northeast2"
  zone                  = "northamerica-northeast2-a"
  num_instances         = 1
  rendered_cloud_config = module.tor_bridge_cloud_config.rendered_cloud_config
}
