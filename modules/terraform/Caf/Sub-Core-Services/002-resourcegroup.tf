locals {
  rg-name = var.override-rg-name == null ? "rg-${local.customer-code}-${local.sub-name}-core-${local.location}" : lower(var.override-rg-name)
}

resource "azurerm_resource_group" "core-services" {
  name     = local.rg-name
  location = local.location
  tags     = local.tags
}

output "rg-name" {
  value = azurerm_resource_group.core-services.name
}
output "rg-location" {
  value = azurerm_resource_group.core-services.location
}