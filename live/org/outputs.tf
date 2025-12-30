output "org_id" {
  description = "The Organization ID"
  value       = module.org.org_id
}

output "root_id" {
  description = "The root ID"
  value       = module.org.root_id
}

output "ou_ids" {
  description = "Map of OU names to their IDs"
  value       = module.org.ou_ids
}

output "accounts_ids" {
  description = "Map of account names to their IDs"
  value       = module.org.account_ids
}

