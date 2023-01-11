variable "project" {
  type        = string
  description = "GCP project id (e.g. data-science-90210)"
}

variable "credentials_file" {
  type        = string
  description = "Path to the JSON key file for editing GCP resources"
}

variable "region" {
  type        = string
  description = "GCP region (e.g. us-central1, northamerica-northeast2, ...)"
}

variable "zone" {
  type        = string
  description = "GCP zone (e.g. us-central1-a, northamerica-northeast2-a, ...)"
}

variable "disk_type" {
  type        = string
  description = "GCP disk type (ssd/magnetic). See https://cloud.google.com/compute/docs/disks/#disk-types."
  default     = "pd-standard"

  validation {
    condition     = var.disk_type == "pd-ssd" || var.disk_type == "pd-standard"
    error_message = "The disk_type variable must be one of: 'pd-ssd', 'pd-standard'."
  }
}

variable "ncpus" {
  type        = number
  description = "Number of vCPUs for the COS appliance VM"
  default     = 1

  validation {
    condition     = can(regex("[0-9][0-9]*", var.ncpus))
    error_message = "The ncpus variable must be an integer."
  }
}

variable "gbmem" {
  type        = number
  description = "Amount of memory (GB) for the COS appliance VM"
  default     = 1

  validation {
    condition     = can(regex("[0-9][0-9]*", var.gbmem))
    error_message = "The gbmem variable must be an integer."
  }
}

variable "num_instances" {
  type        = number
  description = "Number of bridge instances."
  default     = 1

  validation {
    condition     = can(regex("[0-9][0-9]*", var.num_instances))
    error_message = "The num_instances variable must be an integer."
  }
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to file with public ssh key (used for ssh-ing into instance)"
  sensitive   = true
}

variable "allowed_ports" {
  type        = list(number)
  description = "List of allowed port numbers"
  default     = [8000, 8001]
}

variable "rendered_cloud_config" {
  type        = string
  description = "Rendered cloud-config string (i.e. data.cloudinit_config.tor_obfs4_bridge.rendered)"
}
