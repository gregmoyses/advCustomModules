locals {
  rg-name = var.override-rg-name == null ? "rg-${local.base-name}" : lower(var.override-rg-name)
}

resource "azurerm_resource_group" "hub-net" {
  name     = local.rg-name
  location = local.location
  tags     = local.tags
}

output "rg-name" {
  value = azurerm_resource_group.hub-net.name
}
output "rg-location" {
  value = azurerm_resource_group.hub-net.location
}