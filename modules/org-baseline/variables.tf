variable "org_enabled" {
  description = "Flag to enable or disable the organization level settings."
  type        = bool
  default     = true
}


variable "accounts" {
  description = "List of account configurations."
  type = map(object({
    name  = string
    email = string
    ou    = string
  }))
}


