## Simple Sandbox VM Workload Module

### Description
<br>
This module creates a simple sandboxed VM Workload in a dedicated resource group.

Creates the following resources
- Resource Group
<br>
<br><br>  

### ChangeLog

## Version 1.06

Added public IP resource

## Version 1.05

Added Windows virtual machine

## Version 1.04

Added network security group to the subnet

## Version 1.03

Shifted name interpolation to the locals block

## Version 1.02

Calculating subnet from vnet address using local variables and function

## Version 1.01

Added

- Virtual Network creation
- Subnet creation

## Version 1.0

Creates a workload resource group

### Source Path:
 
/advisor-custom-modules/modules/terraform/Workloads/jw-simple-workload
 
<br><br> 

### Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| workload-name | string | True | Name for the workload, will be added to the name of all resources created |
| location | string | False | Location for the workload, if not specified will default to uksouth |
| tags | map | False | A map of tags to attach to resources in this workload, if not specified will default to null (no tags) |
| vnet-address-spaces | list (CIDR IP Ranges as strings) | False | A list of address spaces to add to the created workload vnet defaults to 10.0.0.0/24 |
| vm-size | string | False | VM Size, defaults to Standard_B2s |
| vm-public-ip | bool | False | Whether the VM should have a public IP created defaults to false |


<br>
### Outputs
<br>

| Output Name | Type | Description |
|:--|:--|:--|
| rg-name | string | Resource Group Name |
| rg-id | string | Azure Resource Group ID |
| location | string | Deployment Location |
| vnet-name | string | Workload virtual Network Name |
| vnet-address-spaces | list | List of virtual network address spaces |
| snet-name | string | Workload subnet name |
| snet-address-prefixes | string | Workload subnet name |
| public-ip-address | string | Public ip allocated to the VM if no public ip is created this will be null |

<br>
### Example usage

```

```