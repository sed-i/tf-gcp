#################
# General       #
#################

variable "project" {
  type        = string
  description = "GCP project id"
  default     = "data-science-90210"
}

variable "credentials_file" {
  type        = string
  description = "Path to the JSON key file for editing GCP resources"
  default     = "~/secrets/data-science-90210-40d03fb93e62.json"
}

variable "region" {
  type        = string
  description = "GCP region"
   default     = "us-central1"
#  default = "northamerica-northeast2"
}

variable "zone" {
  type        = string
  description = "GCP zone"
   default     = "us-central1-a"
#  default = "northamerica-northeast2-a"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to file with public ssh key"
  default     = "~/secrets/gcp-tor-obfs4-bridge-ssh.pub"
  sensitive   = true
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to file with private ssh key"
  default     = "~/secrets/gcp-tor-obfs4-bridge-ssh"
  sensitive   = true
}

####################
# VM size          #
####################

variable "disk_type" {
  type        = string
  description = "GCP disk type (ssd/magnetic). See https://cloud.google.com/compute/docs/disks/#disk-types."

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

variable "num_instances" {
  type        = number
  description = "Number of bridge instances."
  default     = 1

  validation {
    condition     = can(regex("[0-9][0-9]*", var.num_instances))
    error_message = "The num_instances variable must be an integer."
  }
}

####################
# tor-obfs4-bridge #
####################

variable "OR_PORT" {
  type        = number
  description = "Onion routing port"
  default     = 8000

  validation {
    condition     = can(regex("[0-9][0-9]*", var.OR_PORT))
    error_message = "The OR_PORT variable must be an integer."
  }
}

variable "PT_PORT" {
  type        = number
  description = "obfs4 port"
  default     = 8001

  validation {
    condition     = can(regex("[0-9][0-9]*", var.PT_PORT))
    error_message = "The PT_PORT variable must be an integer."
  }
}

variable "EMAIL" {
  type        = string
  description = "Your email address"
}
