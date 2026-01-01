output "groups" {
  value = {
    for k, v in aws_identitystore_group.groups :
    k => v.group_id
  }
}

output "permission_set_arns" {
  value = module.permission_sets.permission_set_arns
}

output "account_ids" {
  value = data.terraform_remote_state.org.outputs.accounts_ids
}
