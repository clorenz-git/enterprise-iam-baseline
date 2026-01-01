resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  name             = each.key
  description      = each.value.description
  session_duration = each.value.session_duration
  instance_arn     = var.instance_arn
}

locals {
  policy_attachments = flatten([
    for ps_name, ps in var.permission_sets : [
      for policy_arn in ps.managed_policies : {
        ps_name    = ps_name
        policy_arn = policy_arn
      }
    ]
  ])
}

resource "aws_ssoadmin_managed_policy_attachment" "attach" {
  for_each = {
    for x in local.policy_attachments :
    "${x.ps_name}::${x.policy_arn}" => x
  }

  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
  managed_policy_arn = each.value.policy_arn
}
