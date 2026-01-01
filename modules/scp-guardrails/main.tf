# SCP: Deny IAM user creation in Workloads

resource "aws_organizations_policy" "deny_iam_users" {
  name        = "DenyIAMUserCreation"
  description = "Prevent IAM users in workload accounts. Enforce SSO-only access."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:CreateAccessKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "workloads_deny_iam" {
  policy_id = aws_organizations_policy.deny_iam_users.id
  target_id = var.workloads_ou_id
}


# SCP: Prevent leaving the org

resource "aws_organizations_policy" "deny_leave_org" {
  name        = "DenyLeaveOrganization"
  description = "Prevent member accounts from leaving the organization."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "organizations:LeaveOrganization"
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_leave_org_root" {
  policy_id = aws_organizations_policy.deny_leave_org.id
  target_id = var.root_id
}
