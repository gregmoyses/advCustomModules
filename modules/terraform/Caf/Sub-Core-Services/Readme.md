## Subscription Core Services Module
<br><br>

### Description
<br>
This module is designed to consolidate subscription level core services.

Should contain at least:

- Lighthouse
- Recovery Vault
- Sub level Policy
- Log Analytics
- Automation Account
- Security Center
<br><br>  
 
### Source Path:
 
/advisor-custom-modules/modules/terraform/Caf/Sub-Core-Services
 
<br><br> 

# Changelog

## 1.0.5 25/07/2022

Added
- Subscription diagnostics
- Output Values

## 1.0.4 21/07/2022

Added:
- Recovery Vault

## 1.0.3 21/07/2022

Added:
- Automation Account
- Automation Account Default Modules

## 1.0.2 20/07/2022

Added:
- Defender for Cloud

## 1.0.1 20/07/2022

Added:
- Resource Group
- Log Analytics workspace

## 1.0.0 18/07/2022

Initial version of module

- Lighthouse

<br><br> 

### Global Input Variables

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| subscription-name | string | yes | Name of the subscription, will feed into the names of other resources created by this module, spaces and symbols will be removed |
| customer-code | string | yes | Customer code, added to some resources, must be exactly 3 characters and is validated |
| location | string | yes | Location to deploy the core services ie. uksouth, ukwest, westeurope etc. |
| management-la-id | string | no | An optional id of a log analytics workspace deployed somewhere else. If provided this will be used for the storage of activity logs for this subscription instead of the workspace created by this module |

### Resource Group Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-rg-name | string | no | Overrides the default name for the resource group, by default the name will be 'rg-<customer-code>-<subscription-name>-core-<location>' |

### Log Analytics Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-la-name | string | no | Overrides the default name for the log analytics workspace, by default the name will be 'la-<customer-code>-<subscription-name>-<location>' |
| override-la-retention | number | no | Overrides the default retention period for the la workspace, by default the retention will be 30 days |

### Automation Account Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-aa-name | string | no | Overrides the default name for the automation account, by default the name will be 'aa-<customer-code>-<subscription-name>-<location>' |
| override-aa-identity-name | string | no | Overrides the default name for the automation account managed identity, by default the name will be 'mi-aa-<customer-code>-<subscription-name>-<location>' |
| override-aa-identity-roles | list(string) | no | List of roles to assign to the automation account managed identity at the subscription level. Defaults to 'Virtual Machine Contributor'. Built in roles can be found here https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles |
| aa-add-modules | list(object) | no | List of PSGallery modules to add to the automation account, this will be merged with the default modules defined |

### Recovery Vault Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-rv-name | string | no | Overrides the default name for the recovery vault, by default the name will be 'rv-<customer-code>-<subscription-name>-<location>' |
| override-rv-storage-mode | string | no | Change recovery vault storage mode from the default of 'GeoRedundant'. Accepted values are "GeoRedundant", "LocallyRedundant" or "ZoneRedundant" |
| rv-disable-soft-delete | bool | no | Soft-delete is enabled by default. This option allows for it to be disabled |
| rv-encryption-key-id | string | no | The Key Vault key id used to encrypt this vault. Key managed by Vault Managed Hardware Security Module is also supported. Populating this variable will enable infrastructure encryption on the Vault. Once enabled this setting cannot be changed |

### Defender for Cloud Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-dfc-tiers | map | no | A map of security center tiers to enable for the subscription, by default all tiers will be set to standard |
| deploy-defender-cloud | boolean | no | Option to enable/disable security center deployment. Might be useful if core services are required in multiple regions. Defaults to true |

### Lighthouse Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-lh-namedef               | string    | False | The name of the lighthouse definition |
| override-lh-scope                 | string    | False | The ID of the subscription that the definition will be created in |
| override-lh-assign-scope          | string    | False | The scope that the definition will be created at and assigned to |
| override-lh-description           | string    | False | the description that will be given to the lighthouse definition |
| override-lh-mtenant-id            | string    | False | the ID of the Management Tenant. this defaults to the OneAdvanced's tenant ID |
| override-lh-authorization         | string    | False | A list of objects representing the authorisations provided by the lighthouse dfinition. This object must include principal-id and role-def-id which define the id of the user or group who should be given the permission and the id of the RBAC permission itself, respectively. It can also include principal-display-name which is the name given to the user or group who should be given the permissions and delegated-role-def-ids which is a list of role definitions which the user or group can delegate. |

<br><br> 

### Outputs
<br>

| Output Name | Type | Description |
|:--|:--|:--|
| rg-name | string | Name of the created Resource group |
| rg-location | string | Location of the created resource group |
| aa-id | string | Id of the created automation account |
| la-id | string | Id of the created log analytics workspace |
| rv-id | string | Id of the created recovery vault |
<br>

### Example usage
 
```
module "sub-core" {
  source				                    = "./../../advisor-custom-modules/modules/terraform/Caf/Sub-Core-Services"

  subscription-name                 = "Management"
  customer-code                     = "poc"
  location                          = "uksouth"
  override-lh-authorization		    = [
    {
        principal-id            = "89967ed7-4605-4c60-be5a-eaea9e74441e"
        role-def-id             = "b24988ac-6180-42a0-ab88-20f7382dd24c" // Contributor
        principal-display-name  = "Azure Engineering"
    },
    {
        principal-id            = "89967ed7-4605-4c60-be5a-eaea9e74441e"
        role-def-id             = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9" //User Access Administrator - Limited
        delegated-role-def-ids  = [
            "b24988ac-6180-42a0-ab88-20f7382dd24c", //Contributor
            "92aaf0da-9dab-42b6-94a3-d43ce8d16293" //Log Analytics Contributor
        ]
    },   
  ]
}

```