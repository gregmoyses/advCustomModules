output "rg-name" {
  value = azurerm_resource_group.workload-rg.name
}
output "location" {
  value = var.location
}
output "rg-id" {
  value = azurerm_resource_group.workload-rg.id
}

output "vnet-name" {
  value = azurerm_virtual_network.workload-vnet.name
}

output "vnet-address-spaces" {
  value = azurerm_virtual_network.workload-vnet.address_space
}

output "snet-name" {
  value = azurerm_subnet.workload-snet.name
}

output "snet-address-prefixes" {
  value = azurerm_subnet.workload-snet.address_prefixes
}

output "public-ip-address" {
  value = length(azurerm_public_ip.wl-pip) > 0 ? azurerm_public_ip.wl-pip[0].ip_address : null
}