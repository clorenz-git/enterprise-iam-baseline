output "org_id" {
  description = "The organization ID"
  value       = data.aws_organizations_organization.this
}

output "root_id" {
  description = "The root ID of the organization"
  value       = data.aws_organizations_organization.this.roots[0].id
}

output "ou_ids" {
  description = "A map of organizational unit names to their IDs"
  value = {
    for k, v in aws_organizations_organizational_unit.ou :
    k => v.id
  }
}

output "account_ids" {
  description = "A map of account names to their IDs"
  value = {
    for k, v in aws_organizations_account.acct :
    k => v.id
  }
}

