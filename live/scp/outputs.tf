output "workloads_ou_id" {
  value = data.terraform_remote_state.org.outputs.ou_ids["Workloads"]
}

output "root_id" {
  value = data.terraform_remote_state.org.outputs.root_id
}
