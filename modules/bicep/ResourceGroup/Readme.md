## Simple Resource Group Module
<br><br>

### Description
<br>
This module creates a resource group at a subscription scope.
<br>
<br><br>  
 
### Source Path:
 
/advisor-custom-modules/modules/bicep/ResourceGroup/ResourceGroup.bicep
 
<br><br> 

### Input Variables
<br>

| Variable Name | Type | Required | Description |
|:--|:--|:--|:--|
| nameSuffix | string | True | The suffix to apply to the resource group (The resource group will be named rg-{nameSuffix}) |
| location | string | True | The Azure location to deploy the resource group |

 
<br><br> 

### Outputs
<br>

| Output Name     | Type       | Description                               |
|-----------------|------------|-------------------------------------------|
| rgLocation | string | The location of the resource group |
| rgName | string | The name of the resource group |

<br><br>  
 
### Example usage
 
``` <!-- place module code between the backticks -->

module aResourceGroup './../../advisor-custom-modules/modules/bicep/ResourceGroup/ResourceGroup.bicep' = {
  nameSuffix: 'example'
  location: 'uksouth'
}

```