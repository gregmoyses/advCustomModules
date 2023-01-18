## Module for configuration of Hub Network
<br>

### Description
<br>

This module is for deployment of Hub networking services within the connectivity subscription

Contains:
- Hub Virtual Network
- S2S VPN
- P2S VPN
- Expressroute Config
- Firewall Configuration
- Bastion
- Core Azure DNS

Future
- IPAM

<br>

### Source Path:

/advisor-custom-modules/modules/terraform/Caf/Hub-Network

<br>

# Changelog

## 1.0 (19/07/22 - JW)

**Initial Version**

<br>

### Input Variables
<br>

### Global Input Variables

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| subscription-name | string | yes | Name of the subscription, will feed into the names of other resources created by this module, spaces and symbols will be removed |
| customer-code | string | yes | Customer code, added to some resources, must be exactly 3 characters and is validated |
| location | string | yes | Location to deploy the core services ie. uksouth, ukwest, westeurope etc. |
| management-la-id | string | no | An optional id of a log analytics workspace. If provided this will be used for the storage of diagnostic settings for resources created by this module |
| hub-address-space | string | yes | 

### Resource Group Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-rg-name | string | no | Overrides the default name for the resource group, by default the name will be 'rg-<customer-code>-<subscription-name>-hub-<location>' |

<br>

### Virtual Network Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-vnet-name | string | no | Overrides the default name for the hub virtual network, by default the name will be 'vnet-<customer-code>-<subscription-name>-hub-<location>' |

<br>

### Private DNS Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| private-dns-zones | string | no | A list of private DNS Zones to create and link to the hub network |

<br>

### Bastion Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| disable-bastion | bool | no | Disable the bastion deployment. Defaults to false |
| override-bastion-name | string | no | Override the name of the Bastion |
| override-bastion-pip-name | string | no | Override the name of the Bastion pip |
| override-bastion-zones | list(string) | no | Override the zones for the bastion PIP. Defaults to [] |

<br>

### Firewall Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| disable-firewall | bool | no | A true/false value to allow for the disabling of the Azure Firewall. Defaults to false |
| override-firewall-name | string | no | Overrides the default name for the azure firewall, by default the name will be 'azfw-<customer-code>-<subscription-name>-hub-<location>' |
| override-firewall-pip-name | string | no | Overrides the default name for the azure firewall public ip, by default the name will be 'pip-azfw-<customer-code>-<subscription-name>-hub-<location>' |
| override-firewall-ipcfg-name | string | no | Overrides the default name for the firewall ipconfig, by default the name will be 'ipcfg-azfw-<customer-code>-<subscription-name>-hub-<location>' |
| override-firewall-sku | string | no | SKU for the Azure firewall and policy. Can be Premium or Standard. Will default to Premium |
| override-fw-policy-identity-name | string | no | Overrides the default name for the azure firewall policy, by default the name will be 'azfw-base-policy-<customer-code>-<subscription-name>-hub-<location>' |
| disable-dns-proxy | bool | no | A true/false value to allow for the disabling of the Azure Firewall DNS proxy. Defaults to false |
| firewall-dns-servers | list(string) | no | A list of IP addresses to apply as DNS servers on the firewall. Defaults to using Azure provided DNS |

<br>

### VPN Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| override-gateway-name | string | no | Overrides the default name for the azure vpn, by default the name will be 'vpngw-<customer-code>-<subscription-name>-hub-<location>' |
| override-gateway-pip-name | string | no | Overrides the default name for the azure vpn public ip, by default the name will be 'pip-vpngw-<customer-code>-<subscription-name>-hub-<location>' |
| override-gateway-ipcfg-name | string | no | Overrides the default name for the vpn ipconfig, by default the name will be 'ipcfg-vpngw-<customer-code>-<subscription-name>-hub-<location>' |
| override-gateway-sku | string | no | SKU for the Azure vpn. Will default to VpnGw1 |
| override-gateway-pip-id | string | no | A string with the id of an external public ip to use for the VPN |
| vpn-configs | map(object) | no | A map of objects defining the VPN configs required. This must be supplied to enable the VPN. Defaults to null. See below for schema. |

#### vpn-configs schema

The key of this map should be the name of the location the VPN connects to. The value should be an object with the schema defined below in the example. The ipsec-policy property can be null, in which case a default policy will be applied.

Example:
```
  vpn-configs = {
    London = {
      gateway-address      = "194.86.54.25"
      address-spaces       = ["192.168.10.0/24"]
      dpd-timeout          = 30
      policy-based-traffic = false
      protocol             = "IKEv2"
      routing-weight       = 10
      shared-key           = "zsdfjatgmksryrymsymtsym"
      ipsec-policy         = null #{
      #   dh_group = "ECP256"
      #   ike_encryption = "AES256"
      #   ike_integrity = "SHA256"
      #   ipsec_encryption = "AES256"
      #   ipsec_integrity = "SHA256"
      #   pfs_group = "PFS24"
      #   sa_lifetime = 27000
      #   sa_datasize = 102400000
      # }
    }
  }
```

<br>

### Output Variables
<br>

| Output Name | Type |  Description |
|:--|:--|:--|
| vnet-id | string | Hub Vnet Id |


<br>

### Deployment Example:

```terraform

module "hub-network" {
  source                      = "./../../advisor-custom-modules/modules/terraform/Caf/Hub-Network"
  hub-address-space           = "10.1.0.0/24"
  subscription-name           = local.sub-name
  customer-code               = local.customer-code
  location                    = local.location
  tags                        = local.tags
  private-dns-zones           = ["advancedpoc.net","anotherdomain.com"]
  management-la-id            = data.terraform_remote_state.management.outputs.la-id
  vpn-configs = {
    London = {
      gateway-address      = "194.86.54.25"
      address-spaces       = ["192.168.10.0/24"]
      dpd-timeout          = 30
      policy-based-traffic = false
      protocol             = "IKEv2"
      routing-weight       = 10
      shared-key           = "zsdfjatgmksryrymsymtsym"
      ipsec-policy         = null #{
      #   dh_group = "ECP256"
      #   ike_encryption = "AES256"
      #   ike_integrity = "SHA256"
      #   ipsec_encryption = "AES256"
      #   ipsec_integrity = "SHA256"
      #   pfs_group = "PFS24"
      #   sa_lifetime = 27000
      #   sa_datasize = 102400000
      # }
    }
  }
}

```
