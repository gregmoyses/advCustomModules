locals {
  subnets-size-map        = {
    AzureFirewallSubnet   = 26 
    GatewaySubnet         = 26
    AzureBastionSubnet    = 26
  }
  vnet-prefix = parseint(split("/", azurerm_virtual_network.hub-vnet.address_space[0])[1], 10)
  subnets-list = [
    for snk, snv in local.subnets-size-map : 
      {
        name = snk
        new_bits = snv - local.vnet-prefix
      }
  ]
}

module "hub_snets" {
  source               = "hashicorp/subnets/cidr"
  base_cidr_block      = azurerm_virtual_network.hub-vnet.address_space[0]
  networks             = local.subnets-list
}

resource "azurerm_subnet" "hub_subnet" {
  for_each             = module.hub_snets.network_cidr_blocks
  name                 = each.key
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = [each.value]
  resource_group_name  = azurerm_resource_group.hub-net.name
}