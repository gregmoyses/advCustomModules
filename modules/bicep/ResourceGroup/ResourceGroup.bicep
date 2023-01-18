// set the target scope for this file
targetScope = 'subscription'

@minLength(3)
@maxLength(10)
param nameSuffix string

param location string

var resourceGroupName = 'rg-${nameSuffix}'

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

output rgLocation string = newRG.location
output rgName string = newRG.name
