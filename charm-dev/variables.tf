#################
# General       #
#################

variable "project" {
  type        = string
  description = "GCP project id"
  default     = "modern-unison-342218"
}

variable "credentials_file" {
  type        = string
  description = "Path to the JSON key file for editing GCP resources"
  default     = "~/secrets/modern-unison-342218-e65267bbf995.json"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone"
  default     = "us-central1-a"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to file with public ssh key"
  default     = "~/secrets/gcp-charm-dev-ssh.pub"
  sensitive   = true
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to file with private ssh key"
  default     = "~/secrets/gcp-charm-dev-ssh"
  sensitive   = true
}

#################
# charm-dev     #
#################

variable "disk_type" {
  type        = string
  description = "GCP disk type (ssd/magnetic)"

  validation {
    condition     = var.disk_type == "pd-ssd" || var.disk_type == "pd-standard"
    error_message = "The disk_type variable must be one of: 'pd-ssd', 'pd-standard'."
  }
}

variable "ncpus" {
  type        = number
  description = "Number of vCPUs for the COS appliance VM"

  validation {
    condition     = can(regex("[0-9][0-9]*", var.ncpus))
    error_message = "The ncpus variable must be an integer."
  }
}

variable "gbmem" {
  type        = number
  description = "Amount of memory (GB) for the COS appliance VM"

  validation {
    condition     = can(regex("[0-9][0-9]*", var.gbmem))
    error_message = "The gbmem variable must be an integer."
  }
}

####################
# Revision anchors #
####################

variable "lxd" {
  type        = string
  description = "LXD snap channel"
  default     = "latest/stable"
}

variable "juju" {
  type        = string
  description = "Juju snap channel"
  default     = "latest/stable"
}

variable "microk8s" {
  type        = string
  description = "MicroK8s snap channel"
  default     = "latest/stable"
}

variable "charmcraft" {
  type        = string
  description = "Charmcraft snap channel"
  default     = "latest/stable"
}

