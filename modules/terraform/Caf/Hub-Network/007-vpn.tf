
locals {
  enable-vpn               = var.vpn-configs != null ? toset(["1"]) : toset([]) 
  gateway-name             = var.override-gateway-name == null ? lower("vpngw-${local.base-name}") : lower(var.override-gateway-name)
  gateway-sku              = var.override-gateway-sku  == null ? "VpnGw1" : var.override-gateway-sku
  gateway-ipcfg-name       = var.override-gateway-ipcfg-name == null ? lower("ipcfg-${local.gateway-name}") : lower(var.override-gateway-ipcfg-name)
  gateway-diagnostics      = var.management-la-id == null || var.vpn-configs == null ? toset([]) : toset(["1"])
  gateway-diagnostics-name = "diag-${local.gateway-name }"
  gateway-la-id            = var.management-la-id == null ? null : var.management-la-id
  gateway-la-destination   = "Dedicated"
  gateway-use-azure-ip     = false
  connection-base-name     = "conn-${local.gateway-name}"
  
  gateway-pip-id           = var.override-gateway-pip-id == null ? azurerm_public_ip.pip-vpngw["1"].id : var.override-gateway-pip-id
  gateway-pip-name         = var.override-gateway-pip-name == null ? lower("pip-${local.gateway-name}") : lower(var.override-gateway-pip-name)
  create-pip               = var.override-gateway-pip-id == null && var.vpn-configs != null ? toset(["1"]) : toset([])
  gateway-pip-sku          = 1 == 1 ? "Standard" : "Basic"
  gateway-pip-zones        = 1 == 1 ? null : null
  gateway-pip-allocation   = 1 == 1 ? "Static" : "Dynamic"

  gateway-vpn-type         = 1 == 1 ? "RouteBased" : "RouteBased"
  gateway-type             = 1 == 1 ? "Vpn" : "Vpn"

  enable-bgp               = 1 == 1 ? false : false
  gateway-active-active    = 1 == 1 ? false : false

  default-ipsec-policy = {
    dh_group = "ECP384"
    ike_encryption = "AES256"
    ike_integrity = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity = "SHA256"
    pfs_group = "PFS24"
    sa_lifetime = 27000
    sa_datasize = 102400000
  }

  vpn-configs = var.vpn-configs != null ? {
    for key, config in var.vpn-configs : key => config.ipsec-policy != null ? config : {
      gateway-address = config.gateway-address
      address-spaces = config.address-spaces
      dpd-timeout = config.dpd-timeout
      protocol = config.protocol
      policy-based-traffic = config.policy-based-traffic
      routing-weight = config.routing-weight
      shared-key = config.shared-key
      ipsec-policy = local.default-ipsec-policy
    }
  } : null
}

resource "azurerm_public_ip" "pip-vpngw" {
  for_each                = local.create-pip
  name                    = local.gateway-pip-name
  location                = azurerm_resource_group.hub-net.location
  resource_group_name     = azurerm_resource_group.hub-net.name
  allocation_method       = local.gateway-pip-allocation
  sku                     = local.gateway-pip-sku
  zones                   = local.gateway-pip-zones
  tags                    = local.tags
}

resource "azurerm_virtual_network_gateway" "s2sgw" {
  name                    = local.gateway-name
  location                = azurerm_resource_group.hub-net.location
  resource_group_name     = azurerm_resource_group.hub-net.name

  type                    = local.gateway-type
  vpn_type                = local.gateway-vpn-type

  active_active           = local.gateway-active-active
  enable_bgp              = local.enable-bgp
  sku                     = local.gateway-sku

  ip_configuration {
    name                          = local.gateway-ipcfg-name
    public_ip_address_id          = local.gateway-pip-id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_subnet["GatewaySubnet"].id
  }

  tags                    = local.tags
}

resource "azurerm_local_network_gateway" "onprem-gw" {
  for_each                = local.vpn-configs
  # name                    = "onprem-vpngw-${var.onprem-gw-name-suffix}"
  name                    = "lng-${each.key}"
  location                = azurerm_resource_group.hub-net.location
  resource_group_name     = azurerm_resource_group.hub-net.name
  gateway_address         = each.value.gateway-address
  address_space           = each.value.address-spaces
  tags                    = local.tags
}

resource "azurerm_virtual_network_gateway_connection" "s2sconnection" {
  for_each                    = local.vpn-configs
  # name                        = "vpngw-conn-${var.vpngw-name-suffix}-${var.onprem-gw-name-suffix}"
  name                        = "${local.connection-base-name}-${azurerm_local_network_gateway.onprem-gw[each.key].name}"
  location                    = azurerm_resource_group.hub-net.location
  resource_group_name         = azurerm_resource_group.hub-net.name
  tags                        = local.tags

  local_azure_ip_address_enabled     = local.gateway-use-azure-ip
  dpd_timeout_seconds                = each.value.dpd-timeout
  type                               = "IPsec"
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.s2sgw.id
  local_network_gateway_id           = azurerm_local_network_gateway.onprem-gw[each.key].id
  connection_protocol                = each.value.protocol
  routing_weight                     = each.value.routing-weight
  shared_key                         = each.value.shared-key
  use_policy_based_traffic_selectors = each.value.policy-based-traffic
  
  ipsec_policy {
      dh_group = each.value.ipsec-policy.dh_group
      ike_encryption = each.value.ipsec-policy.ike_encryption
      ike_integrity = each.value.ipsec-policy.ike_integrity
      ipsec_encryption = each.value.ipsec-policy.ipsec_encryption
      ipsec_integrity = each.value.ipsec-policy.ipsec_integrity
      pfs_group = each.value.ipsec-policy.pfs_group
      sa_lifetime = each.value.ipsec-policy.sa_lifetime
      sa_datasize = each.value.ipsec-policy.sa_datasize
  }
}

resource "azurerm_monitor_diagnostic_setting" "vpn-diag-settings" {
  for_each = local.gateway-diagnostics
  name                           = local.gateway-diagnostics-name
  target_resource_id             = azurerm_virtual_network_gateway.s2sgw.id
  log_analytics_workspace_id     = local.gateway-la-id
  log_analytics_destination_type = local.gateway-la-destination

  log {
    category = "GatewayDiagnosticLog"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "TunnelDiagnosticLog"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "RouteDiagnosticLog"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "IKEDiagnosticLog"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  log {
    category = "P2SDiagnosticLog"
    enabled  = true

    retention_policy {
      enabled = true
      days = 30
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 30
      enabled = true
    }
  }
}


# resource "azurerm_route_table" "gateway-routetable" {
#   count                             = var.routes == null ? 0 : 1

#   name                              = "rt-gateway-snet"
#   location                          = var.vnet-location
#   resource_group_name               = var.vnet-rg-name
#   disable_bgp_route_propagation     = var.disable-bgp-route-propagation
  
#   dynamic "route"  {
#     for_each                         = var.routes[*]
#     content {
#     address_prefix                    = route.value.address-prefix
#     name                              = route.value.name
#     next_hop_in_ip_address            = route.value.next-hop-in-ip-address
#     next_hop_type                     = route.value.next-hop-type
#     }
#   }

# }

# resource "azurerm_subnet_route_table_association" "gateway-route-association" {
#   count                   = var.routes == null ? var.route-table-id == null ? 0 : 1 : 1

#   subnet_id               = var.vpngw-subnet-ip-address-prefixes == null ? var.subnet-id : azurerm_subnet.snet-vpngw[0].id 
#   route_table_id          = var.routes == null ? var.route-table-id : azurerm_route_table.gateway-routetable[0].id
# }
