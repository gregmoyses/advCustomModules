## Module for creating default CAF Management Group structure
<br>

### Description
<br>

Creates the default Management group structure for the CAF (Adventureworks) mode.

Supports assigning pre-created subscriptions to the defined management groups.

Structure:
- Tenant Root
  - Customer Root
    - Platform
      - Management
      - Connectivity
      - Identity
    - Workloads
      - Shared
      - Sandbox
    - Unmanaged
<br>

### Source Path:

/advisor-custom-modules/modules/terraform/Caf/ManagementGroups

<br>

# Changelog

## 1.0 (19/07/22 - JW)

**Initial Version**

<br>

### Input Variables
<br>

| Variable Name | Type | Required | Default | Description |
|:--|:--|:--|:--|:--|:--|
| customer-name | string | yes | None | Name of customer and the root management group |
| management-sub-ids | list(string) | no | [] | List of subscription guids to add to the management Management Group |
| connectivity-sub-ids | list(string) | no | [] | List of subscription guids to add to the connectivity Management Group |
| identity-sub-ids | list(string) | no | [] | List of subscription guids to add to the identity Management Group |
| shared-sub-ids | list(string) | no | [] | List of subscription guids to add to the shared Management Group |
| sandbox-sub-ids | list(string) | no | [] | List of subscription guids to add to the sandbox Management Group |
| unmanaged-sub-ids | list(string) | no | [] | List of subscription guids to add to the unmanaged Management Group |
| override-mg-name-platform | string | no | null | Override default management group name |
| override-mg-name-management | string | no | null | Override default management group name |
| override-mg-name-connectivity | string | no | null | Override default management group name |
| override-mg-name-identity | string | no | null | Override default management group name |
| override-mg-name-workloads | string | no | null | Override default management group name |
| override-mg-name-shared | string | no | null | Override default management group name |
| override-mg-name-sandbox | string | no | null | Override default management group name |
| override-mg-name-unmanaged | string | no | null | Override default management group name |

<br>

### Output Variables
<br>

| Output Name | Type |  Description |
|:--|:--|:--|
| root-mg-id | string | Management group resource id |
| platform-mg-id | string | Management group resource id |
| management-mg-id | string | Management group resource id |
| connectivity-mg-id | string | Management group resource id |
| identity-mg-id | string | Management group resource id |
| workloads-mg-id | string | Management group resource id |
| shared-mg-id | string | Management group resource id |
| sandbox-mg-id | string | Management group resource id |
| unmanaged-mg-id | string | Management group resource id |
<br>

### Deployment Example:

```terraform

module "management-groups" {
  source                = "./../../advisor-custom-modules/modules/terraform/Caf/ManagementGroups"
  customer-name         = var.customer-name
  management-sub-ids    = var.management-sub-ids
  connectivity-sub-ids  = var.connectivity-sub-ids
  identity-sub-ids      = var.identity-sub-ids
  shared-sub-ids        = var.shared-sub-ids
  sandbox-sub-ids       = var.sandbox-sub-ids
  unmanaged-sub-ids     = var.unmanaged-sub-ids
}

```
