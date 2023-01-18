locals {
  hub-vnet-name = var.override-vnet-name == null ? lower("vnet-${local.base-name}") : lower(var.override-vnet-name)
  hub-vnet-address-space = var.hub-address-space
}

resource "azurerm_virtual_network" "hub-vnet" {
    name                = local.hub-vnet-name
    address_space       = [local.hub-vnet-address-space]
    location            = azurerm_resource_group.hub-net.location
    resource_group_name = azurerm_resource_group.hub-net.name
    tags                = local.tags
    #dns_servers         = var.dns-servers
}


