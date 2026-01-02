# Enterprise IAM Baseline (AWS Organizations + Identity Center + Terraform)

This project implements a **realistic enterprise-style identity and access management (IAM) baseline** in AWS using Terraform.  
The goal was to model how access is handled at scale: centralized identity, reusable permissions, and org-level guardrails — **not** one-off IAM users and roles.

Everything in this repo was built, verified, documented, and then intentionally torn down to avoid cost.

---

## What this project demonstrates

### ✅ Centralized identity (SSO-first)
- AWS IAM Identity Center (SSO) as the **single entry point** for human access
- No IAM users in workload accounts
- Group-based access instead of user-based permissions

### ✅ Multi-account AWS Organization
- Management (payer) account
- Security account
- Workloads (dev) account
- Organizational Units used to scope policies and guardrails

### ✅ Reusable permission model
- **Permission sets** mapped to common enterprise roles:
  - PlatformAdmin
  - PowerUserDev
  - ReadOnlyAudit
- Assignments follow the pattern:
  **Group → Permission Set → Account**

### ✅ Org-level enforcement with SCPs
- SCP denying IAM user and access key creation in workload accounts
- SCP preventing member accounts from leaving the organization
- Guardrails enforced *above* IAM (cannot be bypassed)

---

## Architecture overview

**Identity**
- IAM Identity Center (SSO)
- Identity Store groups:
  - PlatformAdmins
  - Developers
  - Auditors

**Accounts**
- `security` – restricted admin access
- `workloads-dev` – development workloads only

**Enforcement**
- Service Control Policies (SCPs) attached at OU/root level

This mirrors how enterprises avoid IAM sprawl while maintaining least privilege.

---

## Repo structure

```text
enterprise-iam-baseline/
├── docs/                 # Architecture notes + screenshots
├── modules/
│   ├── org-baseline/     # AWS Organizations + OUs + accounts
│   ├── permission-sets/  # SSO permission set definitions
│   └── scp-guardrails/   # Organization SCPs
└── live/
    ├── org/              # Org instantiation
    ├── scp/              # SCP attachments
    └── identity-center/  # SSO groups, permission sets, assignments
````

Each layer is intentionally separated so identity, org structure, and guardrails can evolve independently — the same way you’d design this in a real environment.

---

## Verification (how this was proven to work)

1. Logged in via **AWS Access Portal (SSO)**
2. Assumed `PowerUserDev` role in `workloads-dev`
3. Attempted to create an IAM user
4. Request was **explicitly denied by SCP**

This confirms:

* SSO access works
* Permission sets are applied correctly
* Org guardrails are enforced regardless of IAM permissions

Screenshots of these steps are included in `/docs`.

---

## Why this matters

In real AWS environments:

* IAM users don’t scale
* Permissions must be reusable
* Guardrails must exist above IAM
* Identity must be centralized

This project focuses on **those exact problems**, using patterns you’ll actually see in production.

---

## Cost & teardown

* AWS Organizations, SCPs, and IAM Identity Center are **free**
* No compute or billable services were left running
* All resources were intentionally destroyed after validation

This repo represents a **complete lifecycle**: design → implement → verify → tear down.

---

## Tools & services used

* Terraform
* AWS Organizations
* IAM Identity Center (SSO)
* Service Control Policies (SCPs)

---

## Notes

This project was built as a learning and portfolio exercise, but the patterns used are directly applicable to real-world enterprise AWS environments.

Recreation is straightforward by following the module order:

1. Organizations
2. SCP guardrails
3. Identity Center

---

If you want to understand how access should be handled **at scale** in AWS, this is the baseline.

```

