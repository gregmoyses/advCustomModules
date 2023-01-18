output "vnet-id" {
  value = azurerm_virtual_network.hub-vnet.id
}

output "firewall-ip" {
  value = azurerm_public_ip.pip-azfw["1"].ip_address
}