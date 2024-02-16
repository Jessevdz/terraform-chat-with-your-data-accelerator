variable "prefix" {
  description = "Resource prefix for all resources."
  type        = string
  default     = "prefix"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "France Central"
}

variable "auth_type" {
  description = "Only keys are implemented."
  type        = string
  default     = "keys"
}
