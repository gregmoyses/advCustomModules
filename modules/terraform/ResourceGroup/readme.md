## Simple Resource Group Module
<br><br>

### Description
<br>
This module creates a resource group
<br>
<br><br>  
 
### Source Path:
 
/advisor-custom-modules/modules/terraform/ResourceGroup
 
<br><br> 

### Input Variables
<br>


| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| rg-suffix | string | True (if no custom-rg-name specified) | The suffix to apply to the resource group (The resource group will be named rg-{nameSuffix}) |
| custom-rg-name | string | True (if no rg-suffix specified) | A complete custom name for the resource group, overrides the default of rg-{nameSuffix}) |
| rg-location | string | True | The Azure location to deploy the resource group |
| tags | map | False | A map of tags to apply to the resource group |

 
<br><br> 

### Outputs
<br>

| Output Name     | Type       | Description                               |
|-----------------|------------|-------------------------------------------|
| rg-location | string | The location of the resource group |
| rg-name | string | The name of the resource group |
| rg-id | string | The Azure resource id of the resource group |

<br><br>  
 
### Example usage
 
``` <!-- place module code between the backticks -->

module "aResourceGroup" {
  source = './../../advisor-custom-modules/modules/terraform/ResourceGroup'
  rg-suffix   = "example"
  rg-location = "uksouth'
}

```