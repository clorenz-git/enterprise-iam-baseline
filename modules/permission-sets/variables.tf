variable "instance_arn" {
  type = string
}

variable "permission_sets" {
  description = "Map of permission set definitions."
  type = map(object({
    description      = string
    session_duration = string
    managed_policies = list(string)
  }))
}
