output "permission_set_arns" {
  value = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}
