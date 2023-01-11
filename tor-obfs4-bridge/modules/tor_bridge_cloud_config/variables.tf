
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
