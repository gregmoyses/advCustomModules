locals {
  bastion-enabled = var.disable-bastion == true ? toset([]) : toset(["1"])
  bastion-name = var.override-bastion-name == null ? lower("bastion-${local.base-name}") : lower(var.override-bastion-name)
  bastion-pip-name = var.override-bastion-pip-name == null ? lower("pip-${local.bastion-name}") : lower(var.override-bastion-pip-name)
  bastion-ipcfg-name = lower("ipcfg-${local.bastion-name}")
  bastion-zones = var.override-bastion-zones == null ? [] : var.override-bastion-zones
}

resource "azurerm_public_ip" "bastion-pip" {
  for_each              = local.bastion-enabled
  name                  = local.bastion-pip-name
  location              = azurerm_resource_group.hub-net.location
  resource_group_name   = azurerm_resource_group.hub-net.name
  allocation_method     = "Static"
  sku                   = "Standard"
  tags                  = local.tags
  zones                 = local.bastion-zones
}

resource "azurerm_bastion_host" "bastion" {
  for_each              = local.bastion-enabled
  name                  = local.bastion-name
  location              = azurerm_resource_group.hub-net.location
  resource_group_name   = azurerm_resource_group.hub-net.name

  ip_configuration {
    name                 = local.bastion-ipcfg-name
    subnet_id            = azurerm_subnet.hub_subnet["AzureBastionSubnet"].id
    public_ip_address_id = azurerm_public_ip.bastion-pip["1"].id
  }

  tags                  = local.tags
}

output "pip-id" {
  value = try(azurerm_public_ip.bastion-pip["1"].id)
}

output "bastion-id" {
  value = try(azurerm_bastion_host.bastion["1"].id)
}